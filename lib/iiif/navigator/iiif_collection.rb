
module IIIF
  module Navigator

    class IIIFCollection < Resource

      attr_reader :manifests
      attr_reader :iiif_manifests
      attr_reader :sc_manifests

      def collection?
        iri_type? RDF::Vocab::IIIF.Collection
      end

      def manifests
        @manifests ||= begin
          manifests = []
          manifests.push(* manifest_uris(query_iiif_manifests))
          manifests.push(* manifest_uris(query_sc_manifests))
          manifests.collect {|m| IIIF::Navigator::Manifest.new(m)}
        end
      end

      def sc_manifests
        @sc_manifests ||= manifest_uris(query_sc_manifests).collect do |s|
          IIIF::Navigator::SharedCanvasManifest.new(s.subject)
        end
      end

      def iiif_manifests
        @iiif_manifests ||= manifest_uris(query_iiif_manifests).collect do |s|
          IIIF::Navigator::IIIFManifest.new(s.subject)
        end
      end


      private

      def manifest_uris(q)
        uris = rdf.query(q).collect {|s| s.subject }
        @@config.array_sampler(uris, @@config.limit_manifests)
      end

      def query_iiif_manifests
        [nil, RDF.type, RDF::Vocab::IIIF.Manifest]
      end

      def query_sc_manifests
        [nil, RDF.type, RDF::SC.Manifest]
      end

    end
  end
end
