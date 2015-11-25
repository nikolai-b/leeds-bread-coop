class StripeApi
  class Invoice
    def initialize(invoice)
      @invoice = invoice
    end

    def total
      sprintf('%.2f', @invoice.total.to_f / 100.0)
    end

    def amount_due
      sprintf('%.2f', (@invoice.amount_due.to_f / 100.0))
    end

    def period_start
      Time.at(@invoice.lines.data[0].period.start).strftime("%d/%m/%Y") #maybe @invoice.period_start
    end

    def period_end
      Time.at(@invoice.lines.data[0].period.end).strftime("%d/%m/%Y") #maybe invoice.lines.data[0].period.end
    end

    def next_payment_attempt
      Time.at(next_payment_attempt_raw).strftime("%d/%m/%Y")
    end

    def next_payment_attempt_raw
      @invoice.next_payment_attempt || Time.new.to_i
    end
  end
end
