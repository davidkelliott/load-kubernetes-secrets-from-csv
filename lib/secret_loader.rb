# frozen_string_literal: true

require 'csv'

class SecretLoader
  def load_from_file_to_kubernetes(file)
    secrets = parse(file)
    upload(secrets) unless secrets == false
  end

  def parse(file)
    puts 'Reading file...'
    begin
      CSV.read(file)
    rescue SystemCallError => e
      puts 'No file found'
      puts "#{e.class}: #{e.message}"
      return false
    end
  end

  def upload(secrets)
    puts 'Uploading secrets...'
    secrets.each do |secret|
      secret_name = secret[0]
      username = secret[1]
      password = secret[2]
      system("kubectl create secret generic #{secret_name} --from-literal=username=#{username} --from-literal=password=#{password}")
      puts "Secret #{secret_name} failed to upload" if $CHILD_STATUS != 0
    end
  end

  def delete(secrets)
    puts 'Deleting secrets...'
    secrets.each do |secret|
      secret_name = secret[0]
      system("kubectl delete secret #{secret_name}")
      puts "Secret #{secret_name} failed to delete" if $CHILD_STATUS != 0
    end
  end
end
