class AccountAppointment < ActiveRecord::Base
  include ModelUtil
  belongs_to :account, foreign_key: 'account_id'
  # belongs_to :user, :through => :account

  validates_presence_of :date, :description, :value, :deb_cre
  validates_presence_of :account_id, message: '- a conta deste lançamento deverá ser informada!'
  validate :verify_balance, :verify_values_negative

  before_save :up_description
  # enum deb_cred: { 'Debito': 'D', 'Credito': 'C'}


  def up_description
    self.description = description.upcase
  end

  def verify_balance

    if (deb_cre == 'D')

      account = Account.find( account_id )


      # require "pry"; binding.pry

      if id
         balance_after_insert = ((account.balance + value_was)- value)
      else
        balance_after_insert = (account.balance - value)
      end

      if (balance_after_insert < 0)
          errors.add(:value, "Saldo indisponivel para este lançamento! Saldo #{balance_after_insert}")
      end

    end

  end

  def verify_values_negative
    errors.add(:value, "Valores negativos não são permitidos o seu lançamento!") if (value <= 0)
  end


  def value_br
    # money_number_br(value)
    ActionController::Base.helpers.number_to_currency(value)
  end


end
