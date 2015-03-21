class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :create_order
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def create_order(email)
    
    require 'bigdecimal'
    require 'bigdecimal/util'
    
    @amount = $PRODUCT_PRICE.to_i/100.0 # price in EUR
    
    @order = Order.create(
      :email => email,
      :amount => "#{@amount}",
      :content => "#{Rails.application.secrets.product_title}",
      :currency    => 'eur',
      :status    => 'pending'
      )
      
    if @order.save
      # require 'bitcoin-addrgen' # uses bitcoin-addrgen gem relying on ffi gem to call gmp C library
      # @btc_address = BitcoinAddrgen.generate_public_address($MPK, @order.id)

      # using paymium_api gem:
      @client = Paymium::Api::Client.new  host: 'https://paymium.com/api/v1',
                                          key: Rails.application.secrets.paymium_api_key,
                                          secret: Rails.application.secrets.paymium_secret_key
                                       
      payment_request = @client.post '/merchant/create_payment',  amount:"#{@order.amount}" , 
                                                                  payment_split:"0", 
                                                                  currency:"EUR",
                                                                  callback_url: "#{$ORDERS_URL}callback"
          
      @order.address = payment_request["payment_address"]
      @btc_amount = payment_request["btc_amount"]
      @order.balance = @btc_amount.to_d
		  @order.qrcode_string = "bitcoin:#{@order.address}?amount=#{@btc_amount}" # warning: make sure the number of decimals here matches that of the Paymium API
      @order.save

      end
    
  end
  
  protected
  
  def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :remember_me) }
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit( :email, :password, :remember_me) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :current_password) }
    end
  
end
