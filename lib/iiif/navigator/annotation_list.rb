
module IIIF
  module Navigator

    class AnnotationList < Resource

      include OpenAnnotationHarvest

      attr_reader :open_annotations

      def annotation_list?
        sc_annotation_list? || iiif_annotation_list?
      end

      def iiif_annotation_list?
        iri_type? RDF::Vocab::IIIF.AnnotationList
      end

      def sc_annotation_list?
        iri_type? RDF::SC.AnnotationList
      end

      def open_annotations
        @open_annotations ||= begin
          oa_graphs = collect_open_annotations
          oa_graphs = @@config.array_sampler(oa_graphs, @@config.limit_openannos)
          oa_graphs.collect {|oa| IIIF::Navigator::OpenAnnotation.new(oa)}
        rescue => e
          binding.pry if @@config.debug
          @@config.logger.error(e.message)
        end
      end

    end
  end
end
