class Hash

  #  Hash which auto initializes it's children.
  #
  #   ah = Hash.autonew
  #   ah['section one']['param one'] = 4
  #   ah['section one']['param two'] = 5
  #   ah['section one']['param three'] = 2
  #   ah['section one']['param four'] = 3
  #
  #   p ah
  #   # {"section one"=>{"param one"=>4, "param four"=>3, "param three"=>2, "param two"=>5}}
  #
  #   p ah['section one'].keys
  #   # ["param one", "param four", "param three", "param two"]
  #
  #   CREDIT: Trans
  #   CREDIT: Jan Molic

  def self.autonew(*args)
    #new(*args){|a,k| a[k] = self.class::new(*args)}
    leet = lambda { |hsh, key| hsh[key] = new( &leet ) }
    new(*args,&leet)
  end

end
