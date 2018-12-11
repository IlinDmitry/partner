module DiaperBankClient
  def self.post(partner_id)
    return unless Rails.env.production?

    partner = { partner:
      { diaper_partner_id: partner_id } }

    uri = URI(ENV["DIAPERBANK_APPROVAL_URL"])

    response = https(uri).request(post_request(uri: uri, body: partner.to_json))

    response.body
  end

  def self.get_available_items(diaper_bank_id)
    return unless Rails.env.production?

    uri = URI(ENV["DIAPERBANK_PARTNER_REQUEST_URL"] + "/#{diaper_bank_id}")
    req = Net::HTTP::Get.new(uri)

    req["Content-Type"] = "application/json"
    req["X-Api-Key"] = ENV["DIAPERBANK_KEY"]

    response = https(uri).request(req)

    if response.code.to_i == 200
      JSON.parse(response.body)
    else
      []
    end
  end

  def self.request_submission_post(partner_request_id)
    return unless Rails.env.production?
    return unless PartnerRequest.exists?(partner_request_id)

    uri = URI(ENV["DIAPERBANK_PARTNER_REQUEST_URL"])
    body = PartnerRequest.find(partner_request_id).export_json

    response = https(uri).request(post_request(uri: uri, body: body))

    response.body
  end

  def self.https(uri)
    Net::HTTP.new(uri.host, uri.port).tap do |http|
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end

  def self.post_request(uri:, body:, content_type: "application/json")
    req = Net::HTTP::Post.new(uri)
    req.body = body
    req["Content-Type"] = content_type
    req["X-Api-Key"] = ENV["DIAPERBANK_KEY"]
    req
  end
end
