require_relative '../test_helper'

class InvoiceTest < ChargoverRubyTest

  def test_exists
    assert Chargeover::Invoice
  end

  def test_should_find_and_invoice_by_id
    VCR.use_cassette('one_invoice', :match_requests_on => [:anonymized_uri]) do

      invoice = Chargeover::Invoice.find(10000)
      assert_equal Chargeover::Invoice, invoice.class

      assert_equal 'https://imagerelay-staging.chargeover.com/r/invoice/pdf/lfthab4s5rgz', invoice.url_pdflink

    end
  end

  def test_should_void_an_invoice
    VCR.use_cassette('void_invoice', :match_requests_on => [:anonymized_uri]) do
      invoice = Chargeover::Invoice.find(10016)
      assert invoice.void
      invoice = Chargeover::Invoice.find(10016)
      assert invoice.void_datetime
    end
  end

  def test_should_email_an_invoice
    VCR.use_cassette('send_invoice', :match_requests_on => [:anonymized_uri]) do
      invoice = Chargeover::Invoice.find(10016)
      assert invoice.send_email
    end
  end

end