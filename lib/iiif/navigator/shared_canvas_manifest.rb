
module IIIF
  module Navigator

    # A filter to exclude any IIIF namespace content
    class SharedCanvasManifest < Manifest

      def manifest?
        sc_manifest?
      end

      def iiif_manifest?
        false
      end

      def annotation_lists
        @annotation_lists ||= begin
          uris = collect_annotation_list_uris(query_sc_annotation_list)
          uris.collect {|uri| Annotations2triannon::AnnotationList.new(uri) }
        end
      end

      def iiif_annotation_lists
        @iiif_annotation_lists ||= []
      end

    end
  end
end
