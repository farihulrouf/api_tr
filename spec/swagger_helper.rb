# frozen_string_literal: true

# Load Rails environment so that Rails constants (like Rails.root) are available
require File.expand_path('../config/environment', __dir__)

# Load RSpec configuration
require 'rails_helper'

RSpec.configure do |config|
  # Lokasi folder output swagger
  # File hasil generate akan tersimpan di: swagger/v1/swagger.yaml
  config.openapi_root = Rails.root.join('swagger').to_s

  # Definisi dokumen swagger
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'V Wallet API',
        version: 'v1',
        description: 'Dokumentasi API untuk laporan dan wallet pada sistem V Wallet'
      },
      paths: {},
      servers: [
        {
          url: '{protocol}://{defaultHost}',
          variables: {
            protocol: {
              default: 'http'
            },
            defaultHost: {
              default: 'localhost:3000'
            }
          }
        }
      ]
    }
  }

  # Format file output (yaml/json)
  config.openapi_format = :yaml
end
