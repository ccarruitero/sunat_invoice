require 'savon'
require 'gyoku'

module SunatInvoice
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :account_ruc, :account_user, :account_password
  end

  class Client
    def initialize env="dev"
      bill_service_path = self.send("#{env}_server")
      @bill_service = Savon.client(wsdl: bill_service_path)
      @consult_service = Savon.client(wsdl: self.consult_server)
    end

    def prod_server
      "https:// www.sunat.gob.pe/ol-ti-itcpfegem/billService"
    end

    def dev_server
      "https://www.sunat.gob.pe/ol-ti-itcpgem-sqa/billService"
    end

    def consult_server
      "https://www.sunat.gob.pe/ol-it-wsconscpegem/billConsultService"
    end

    def prepare_zip
      # xml should be sended insided zip
    end

    def generate_xml hash
      Gyoku.xml(hash)
    end
  end
end
