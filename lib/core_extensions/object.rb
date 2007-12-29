module CoreExtensions
  module Object
    def send_with_default(method, default = nil, *args)
      !self.nil? && self.respond_to?(method) ? self.send(*args.unshift(method)) : default
    end
  end
end

Object.send(:include, CoreExtensions::Object)
