class Sale < ActiveRecord::Base
	before_create :populate_guid
	belongs_to :book

	include AASM

	aasm column: 'state' do
		state :pending, initial: true
		state :processing
		state :finished
		state :errored

		event :process, after: :charge_card do
			transaction from: :pending, to: :processing
		end

		event :finish do
			transaction from: :processing, to: :finished
		end

		event :fail do
			transaction from: :processing, to: :errored
		end
	end

	def charge_card
		begin
			save!
			charge = Stripe::Charge.create(
				amount: self.amount
				currency: "usd"
				card: self.stripe_token
				description: "Book Sale"
				)
			self.update(stripe_id: charge.id)
			self.finish!
		rescue Stripe::StripeError => e
			self.update_attributes(error: e.message)
			self.fail!
		end

	end

	private

	def populate_guid
		self.guid = SecureRandom.uuid()
	end
end
