# base service class for all the application services
class ApplicationService
    def self.call(*args, &block)
      new(*args, &block).call
    end
  end