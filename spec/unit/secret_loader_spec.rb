# frozen_string_literal: true

require_relative '../../lib/secret_loader'

describe SecretLoader do
  let(:secret_loader) { SecretLoader.new }
  let(:secret_array) do
    [
      ['secret-name1', 'username1', 'password1'],
      ['secret-name2', 'username2', 'password2']
    ]
  end
  let(:secret_array_with_error) do
    [
      %w[secret_name1 username1 password1],
      %w[secret_name2 username2 password2]
    ]
  end

  describe 'parse' do
    it 'loads a file from CSV into an array' do
      expect(secret_loader.parse('./spec/system/test.csv')).to eq(
        [
          ['secret-name1', 'username1', 'password1'],
          ['secret-name2', 'username2', 'password2']
        ]
      )
    end

    it 'returns false if file can\'t be loaded' do
      expect(secret_loader.parse('non-existent-file.csv')).to be false
    end
  end

  describe 'upload' do
    after(:each) do
      SecretLoader.new.delete(
        [
          ['secret-name1', 'username1', 'password1'],
          ['secret-name2', 'username2', 'password2']
        ]
      )
    end

    it 'returns a sucess message' do
      expect { secret_loader.upload(secret_array) }.to output(
        "Uploading secrets...\n"\
        "secret/secret-name1 created\n"\
        "secret/secret-name2 created\n"
      ).to_stdout_from_any_process
    end

    it 'returns an error message when the upload fails' do
      expect { secret_loader.upload(secret_array_with_error) }.to output(
        "Uploading secrets...\n"\
        "Secret secret_name1 failed to upload\n"\
        "Secret secret_name2 failed to upload\n"
      ).to_stdout_from_any_process
    end
  end

  describe 'delete' do
    it 'returns sucess message when secret deleted' do
      secret_loader.upload(secret_array)
      expect { secret_loader.delete(secret_array) }.to output(
        "Deleting secrets...\n"\
        "secret \"secret-name1\" deleted\n"\
        "secret \"secret-name2\" deleted\n"
      ).to_stdout_from_any_process
    end
  end
end
