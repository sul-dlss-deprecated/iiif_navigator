
module IIIF
  module Navigator

    # A filter to exclude any Shared Canvas namespace content
    class IIIFManifest < Manifest

      def manifest?
         iiif_manifest?
      end

      def sc_manifest?
        false
      end

      def annotation_lists
        @annotation_lists ||= begin
          uris = collect_annotation_list_uris(query_iiif_annotation_list)
          uris.collect {|uri| IIIF::Navigator::AnnotationList.new(uri) }
        end
      end

      def sc_annotation_lists
        @sc_annotation_lists ||= []
      end

    end
  end
end
