Rswag::Api.configure do |c|
  c.openapi_root = Rails.root.join("openapi").to_s
end

Rswag::Ui.configure do |c|
  c.openapi_endpoint "/api-docs/v1/openapi.yaml", "Techraids API V1"
end
