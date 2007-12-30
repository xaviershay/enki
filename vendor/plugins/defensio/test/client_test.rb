require File.dirname(__FILE__) + "/test_helper"

class ClientTest < Test::Unit::TestCase
  def setup
    @client = Defensio::Client.new :api_key   => API_KEY,
                                   :owner_url => OWNER_URL
  end
  
  def test_convert_name
    assert_equal 'api-key', @client.send(:convert_name, :api_key)
    assert_equal 'hi-there', @client.send(:convert_name, 'hi-there')
  end
  
  def test_convert_params
    assert_equal({ 'api-key' => '123', 'something-a' => 'cool' },
                 @client.send(:convert_params, :api_key => '123', 'something-a' => 'cool'))
  end
  
  def test_validate_valid_key
    response = @client.validate_key
    assert_success response
    assert_not_nil response.message
  end
  
  def test_validate_invalid_key
    @client.api_key = 'thisisinvalid'
    response = @client.validate_key
    assert !response.success?
  end
  
  def test_announce_article
    response = @client.announce_article :article_author => 'marc',
                                        :article_author_email => 'macournoyer@gmail.com',
                                        :article_title => "Rails plugin test #{Time.now}",
                                        :article_content => "I'm just testing",
                                        :permalink => "http://code.macournoyer.com/svn/plugins/defensio/#{Time.now.to_i}"
    assert_success response
  end
  
  def test_audit_comment_with_mandatory_fields
    response = @client.audit_comment :user_ip => '10.211.55.2',
                                     :article_date => '2007/01/01',
                                     :comment_author => 'marc',
                                     :comment_type => 'comment'
    assert_success response
  end
  
  def test_report_false_negatives
    response = @client.report_false_negatives :signatures => '123'
    assert_success response
  end
  
  def test_report_false_positives
    response = @client.report_false_negatives :signatures => '123'
    assert_success response
  end
  
  def test_get_stats
    response = @client.get_stats
    assert_success response
    assert_kind_of Float, response.accuracy
    assert_kind_of Fixnum, response.spam
    assert_kind_of Fixnum, response.ham
    assert_kind_of Fixnum, response.false_positives
    assert_kind_of Fixnum, response.false_negatives
  end
  
  private
    def assert_success(response)
      assert response.success?, response.message
    end
end
