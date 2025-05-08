class AddressZipCodeExtractor
    def self.extract(address)
      return unless address
  
      # USA: 5-digit zip code
      return $1 if address =~ /\b(\d{5})(?:[-\s]\d{4})?\b/
  
      # Canada: A1A 1A1 format having spaces in between
      return $1.delete(' ') if address =~ /\b([A-Za-z]\d[A-Za-z] ?\d[A-Za-z]\d)\b/
  
      # UK: Alpha numeric format with spaces (e.g. WC2E 7HQ)
      return $1 if address =~ /\b([A-Z]{1,2}\d{1,2}[A-Z]?\s?\d[A-Z]{2})\b/i

      nil
    end
  end
  