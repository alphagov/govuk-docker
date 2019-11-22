module ServicesHelper
  def self.names
    Dir.glob("*", base: "services")
  end
end
