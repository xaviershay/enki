namespace :enki do
  desc "Generates public/yadis.xrdf from enki.yml, for OpenID delegation"
  task :generate_yadis => :environment do
    file = "public/yadis.xrdf"
    raise "#{file} already exists, please remove it before running this task" if File.exists?(file)
    enki_config = Enki::Config.default
    raise "open_id_delegation section not provided in config/enki.yml" unless enki_config[:open_id_delegation]
    File.open("public/yadis.xrdf", "w") do |f|
      f.write <<-EOS
<xrds:XRDS xmlns:xrds="xri://$xrds" xmlns="xri://$xrd*($v*2.0)"
      xmlns:openid="http://openid.net/xmlns/1.0">
  <XRD>

    <Service priority="1">
      <Type>http://openid.net/signon/1.0</Type>
      <URI>#{enki_config[:open_id_delegation, :server]}</URI>
      <openid:Delegate>#{enki_config[:open_id_delegation, :delegate]}</openid:Delegate>
    </Service>

  </XRD>
</xrds:XRDS>
      EOS
    end
  end

  desc "Cleans out actions older than 7 days"
  task :clean_actions => :environment do
    UndoItem.delete_all(["created_at < ?", 7.days.ago])
  end
end
