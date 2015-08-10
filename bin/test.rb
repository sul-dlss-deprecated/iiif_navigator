#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'

require 'iiif_navigator'
CONFIG = IIIF::Navigator.configuration


# TODO: add CLI interface for arguments to modify:
# - reporting annotation counts (default=true)

# TODO: Abstract this test script into a generic CLI that takes an
# additional set of arguments to process any of the following:
# - IIIF collection URI
# - IIIF manifest URI
# - IIIF annotation list URI


def dump_json(filename, data)
  File.open(filename,'w') do |f|
    f.write(JSON.pretty_generate(data))
  end
end

def report_anno_counts(annos, anno_count_file)
  anno_count_data = {}
  annos.each_pair do |m,alists|
    puts "\n#{m}"
    anno_count_data[m] = {}
    alists.each_pair do |alist, oa_arr|
      puts "\t#{alist}\t=> #{oa_arr.length}"
      anno_count_data[m][alist] = oa_arr.length
    end
  end
  # persist the anno counts
  dump_json(anno_count_file, anno_count_data)
  puts "\nAnnotation counts saved to: #{anno_count_file}"
end


# -----------------------------------------------------------------------
# Annotation tracking using a file

anno_file = 'annotation_tracking.json'
anno_tracker = IIIF::Navigator::AnnotationTracker.new(anno_file)

puts "\nAnnotation archive:"
anno_tracker.archive
anno_tracker.save({})

# -----------------------------------------------------------------------
# Loading IIIF annotations from a collection

IIIF_COLLECTION='http://dms-data.stanford.edu/data/manifests/collections/collection.json'
puts "\nCollection:\n#{IIIF_COLLECTION}"

iiif_navigator = IIIF::Navigator::IIIFNavigator.new(IIIF_COLLECTION);

puts "\nManifests:"
manifests = iiif_navigator.manifests;
manifests.each {|m| puts m.iri}

puts "\nAnnotation List counts:"
annotation_lists = iiif_navigator.annotation_lists;
annotation_lists.each_pair {|m,alist| puts "#{m} => #{alist.length}"}

puts "\nOpen Annotation counts:"
anno_count_file = File.join(CONFIG.log_path, 'annotation_counts.json')
open_annotations = iiif_navigator.open_annotations;
report_anno_counts(open_annotations, anno_count_file)

# Find all annotations where the body is text
text_annotations = {}
manifest_keys = open_annotations.keys
manifest_keys.each do |mk|
  text_annotations[mk] = {}
  anno_list_keys = open_annotations[mk].keys
  anno_list_keys.each do |ak|
    anno_list = open_annotations[mk][ak]
    anno_text_list = anno_list.select {|oa| oa if oa.body_contentAsText? }
    text_annotations[mk][ak] = anno_text_list
  end
end
puts "\nOpen Annotations with ContextAsText body:"
anno_count_file = File.join(CONFIG.log_path, 'annotation_text_counts.json')
report_anno_counts(text_annotations, anno_count_file)

