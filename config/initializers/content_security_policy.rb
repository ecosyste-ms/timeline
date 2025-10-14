SecureHeaders::Configuration.default do |config|
  config.csp = {
    default_src: %w('self'),
    script_src: %w('self' 'unsafe-inline' 'unsafe-hashes' 'sha256-pwQduWxX3Cm7lLbQmAos7n73RLP4QrsCDFejmsBdZ78=' https://cdnjs.cloudflare.com http://cdnjs.cloudflare.com https://cdn.jsdelivr.net http://cdn.jsdelivr.net https://unpkg.com http://unpkg.com https://static.cloudflareinsights.com http://static.cloudflareinsights.com),
    style_src: %w('self' 'unsafe-inline' https://fonts.googleapis.com https://unpkg.com http://unpkg.com),
    font_src: %w('self' https://fonts.gstatic.com),
    img_src: %w('self' data: https:),
    connect_src: %w('self' *.ecosyste.ms https://cdn.jsdelivr.net http://cdn.jsdelivr.net https://static.cloudflareinsights.com)
  }
end
