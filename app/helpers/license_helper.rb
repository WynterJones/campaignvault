module LicenseHelper
  def encrypt(input_string)
    Base64.encode64(input_string)
  end

  def decrypt(encrypted_string)
    Base64.decode64(encrypted_string)
  end

  def checkLicense
    if ENV['LICENSE_KEY'].present?
      # Hey there, rather than crack the license key (easy, eh?) you can buy a license here: https://campaignvault.com/
      license_key = decrypt(ENV['LICENSE_KEY'])
      if license_key.include? '-campaignvault'
        is_license_valid = true
      else
        is_license_valid = false
      end
    else
      is_license_valid = false
    end
    return is_license_valid
  end
end
