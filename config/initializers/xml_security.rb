module XMLSecurity
  class SignedDocument
    attr_reader :supplied_digest, :calculated_digest, :canon_elements

    def validate_doc(base64_cert, soft = true)
      # validate references

      # check for inclusive namespaces
      inclusive_namespaces = extract_inclusive_namespaces

      document = Nokogiri.parse(self.to_s)

      # create a working copy so we don't modify the original
      @working_copy ||= REXML::Document.new(self.to_s).root

      # store and remove signature node
      @sig_element ||= begin
        element = REXML::XPath.first(@working_copy, "//ds:Signature", {"ds"=>DSIG})
        element.remove
      end


      # verify signature
      signed_info_element     = REXML::XPath.first(@sig_element, "//ds:SignedInfo", {"ds"=>DSIG})
      noko_sig_element = document.at_xpath('//ds:Signature', 'ds' => DSIG)
      noko_signed_info_element = noko_sig_element.at_xpath('./ds:SignedInfo', 'ds' => DSIG)
      canon_algorithm = canon_algorithm REXML::XPath.first(@sig_element, '//ds:CanonicalizationMethod', 'ds' => DSIG)
      canon_string = noko_signed_info_element.canonicalize(canon_algorithm)
      noko_sig_element.remove

      # check digests
      REXML::XPath.each(@sig_element, "//ds:Reference", {"ds"=>DSIG}) do |ref|
        uri                           = ref.attributes.get_attribute("URI").value

        hashed_element                = document.at_xpath("//*[@ID='#{uri[1..-1]}']")
        canon_algorithm               = canon_algorithm REXML::XPath.first(ref, '//ds:CanonicalizationMethod', 'ds' => DSIG)
        canon_hashed_element          = hashed_element.canonicalize(canon_algorithm, inclusive_namespaces).gsub('&','&amp;')

        digest_algorithm              = algorithm(REXML::XPath.first(ref, "//ds:DigestMethod"))

        hash                          = digest_algorithm.digest(canon_hashed_element)
        digest_value                  = Base64.decode64(REXML::XPath.first(ref, "//ds:DigestValue", {"ds"=>DSIG}).text)

        @supplied_digest   = digest_value
        @calculated_digest = hash
        @canon_elements    = canon_hashed_element

        unless digests_match?(hash, digest_value)
          return soft ? false : (raise Onelogin::Saml::ValidationError.new("Digest mismatch"))
        end
      end

      base64_signature        = REXML::XPath.first(@sig_element, "//ds:SignatureValue", {"ds"=>DSIG}).text
      signature               = Base64.decode64(base64_signature)

      # get certificate object
      cert_text               = Base64.decode64(base64_cert)
      cert                    = OpenSSL::X509::Certificate.new(cert_text)

      # signature method
      signature_algorithm     = algorithm(REXML::XPath.first(signed_info_element, "//ds:SignatureMethod", {"ds"=>DSIG}))

      unless cert.public_key.verify(signature_algorithm.new, signature, canon_string)
        return soft ? false : (raise Onelogin::Saml::ValidationError.new("Key validation error"))
      end

      return true
    end
  end
end
