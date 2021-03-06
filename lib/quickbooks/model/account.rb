module Quickbooks
  module Model
    class Account < BaseModel
      XML_COLLECTION_NODE = "Account"
      XML_NODE = "Account"
      REST_RESOURCE = 'account'

      ASSET = 'Asset'
      EQUITY = 'Equity'
      EXPENSE = 'Expense'
      LIABILITY = 'Liability'
      REVENUE = 'Revenue'

      ACCOUNT_CLASSIFICATION = [ASSET, EQUITY, EXPENSE, LIABILITY, REVENUE]

      xml_name XML_NODE

      xml_accessor :id, :from => 'Id', :as => Integer
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :has_attachment, :from => 'HasAttachment'
      xml_accessor :name, :from => 'Name'
      xml_accessor :description, :from => 'Description'

      xml_accessor :sub_account, :from => 'SubAccount'
      xml_accessor :parent_ref, :from => 'ParentRef', :as => BaseReference

      xml_accessor :active, :from => 'Active'

      xml_accessor :classification, :from => 'Classification'
      xml_accessor :account_type, :from => 'AccountType'
      xml_accessor :account_sub_type, :from => 'AccountSubType'

      xml_accessor :acct_num, :from => 'AcctNum'
      xml_accessor :bank_num, :from => 'BankNum'

      xml_accessor :opening_balance, :from => 'OpeningBalance', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :opening_balance_date, :from => 'OpeningBalanceDate', :as => DateTime
      xml_accessor :currency_ref, :from => 'CurrencyRef', :as => BaseReference
      xml_accessor :tax_account, :from => 'TaxAccount'
      xml_accessor :tax_code_ref, :from => 'TaxCodeRef', :as => BaseReference

      reference_setters :parent_ref, :currency_ref, :tax_code_ref

      #== Validations
      validates_inclusion_of :classification, :in => ACCOUNT_CLASSIFICATION
      validates_length_of :name, :minimum => 1, :maximum => 100
      validates_length_of :description, :minimum => 1, :maximum => 100
      validate :name_cannot_contain_invalid_characters

      def name_cannot_contain_invalid_characters
        if name && (name.index(':') || name.index('"'))
          errors.add('name', ":#{name} cannot contain a colon (:) or double quotes (\").")
        end
      end

      def valid_for_update?
        if sync_token.nil?
          errors.add(:sync_token, "Missing required attribute SyncToken for update")
        end
        errors.empty?
      end

      def valid_for_create?
        valid?
        errors.empty?
      end

      def valid_for_deletion?
        return false if(id.nil? || sync_token.nil?)
        id.to_i > 0 && !sync_token.to_s.empty? && sync_token.to_i >= 0
      end

      def has_attachment?
        has_attachment.to_s == 'true'
      end

      def sub_account?
        sub_account.to_s == 'true'
      end

      def active?
        active.to_s == 'true'
      end

      def tax_account?
        tax_account.to_s == 'true'
      end
    end
  end
end
