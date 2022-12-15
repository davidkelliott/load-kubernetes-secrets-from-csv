# frozen_string_literal: true

require_relative '../../lib/secret_loader'

describe SecretLoader do
  let(:secret_loader) { SecretLoader.new }

  describe 'load secrets' do
    after(:all) do
      SecretLoader.new.delete(
        [
          ['secret-name1', 'username1', 'password1'],
          ['secret-name2', 'username2', 'password2']
        ]
      )
    end

    it 'sucessfully loads secrets from a valid csv file' do
      expect { secret_loader.load_from_file_to_kubernetes('./spec/system/test.csv') }.to output(
        "Reading file...\n"\
        "Uploading secrets...\n"\
        "secret/secret-name1 created\n"\
        "secret/secret-name2 created\n"
      ).to_stdout_from_any_process
    end

    it 'gives an error message when the file is not read' do
      expect { secret_loader.load_from_file_to_kubernetes('non-existent-file.csv') }.to output(
        "Reading file...\n"\
        "No file found\n"\
        "Errno::ENOENT: No such file or directory @ rb_sysopen - non-existent-file.csv\n"
      ).to_stdout_from_any_process
    end

    it 'gives an error message when the secrets are not loaded' do
      expect { secret_loader.load_from_file_to_kubernetes('./spec/system/invalid_test.csv') }.to output(
        "Reading file...\n"\
        "Uploading secrets...\n"\
        "Secret secret_name1 failed to upload\n"\
        "Secret secret_name2 failed to upload\n"
      ).to_stdout_from_any_process
    end
  end
end
