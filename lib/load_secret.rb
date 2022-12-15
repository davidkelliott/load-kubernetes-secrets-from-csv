# frozen_string_literal: true

require_relative 'secret_loader'

secret_loader = SecretLoader.new
secret_loader.load_from_file_to_kubernetes(ARGV[0])
