class ProductsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :list, :purchase, :store, :show]
  # before_filter :identify_product, :except => [:index, :list, :purchase, :new, :create,:document_download, :edit, :show]
  
  def document_download
     @product = Product.find(params[:id])
     @file = "product_" + @product.id.to_s
     @path = @product.document.url
      if !@path.nil?
        data = open(@path) 
        send_data data.read, filename: "monfichier.epub", type: "application/epub+zip", disposition: 'attachment', stream: 'true', buffer_size: '4096'
        # send_data data.read, filename: "monfichier.pdf", type: "application/pdf", disposition: 'attachment', stream: 'true', buffer_size: '4096'
        # redirect_to(@path)
  else 
         redirect_to list_products_path
  end
  end

  def video_download
     @product = Product.find(params[:id])
      file_path = @product.video_file_name
      if !file_path.nil?
  send_file "#{Rails.root}/public/system/photos/#{@product.id}/original/#{file_path}", :x_sendfile => true 
  else 
         redirect_to list_products_path
  end
  end

  def audio_download
     @product = Product.find(params[:id])
      file_path = @product.audio_file_name
      if !file_path.nil?
  send_file "#{Rails.root}/public/system/audios/#{@product.id}/original/#{file_path}", :x_sendfile => true 
  else 
         redirect_to list_products_path
  end
  end
  
  def list
    @products = Product.all
  end
  
  def index
    @products = Product.all
  end
  
  def store
    @products = Product.all.select { |m| m.stock != 0 and m.first_category != "membership" }
  end
  
  def new
    @product = Product.new
  end

  def show
    @product = Product.find_by_id(params[:id])
    # send_file @path, :disposition => "attachment; filename=#{@file}"
  end
  
  def purchase 
    @products = Product.where(id: params[:id]).to_a
    # @products = Product.find_all_by_id(params[:id])
    # @products = Product.all.select { |m| m.id == @product.id }
    render "visitors/index"
  end
  
  def create
      @product = Product.new(product_params)

      if @product.save
        redirect_to @product, notice: 'Product was successfully created.'
       else
         render action: 'new'
      end
    end
    
  def edit
    @product = Product.find_by_id(params[:id])
  end
  
  def update
    @product = Product.find_by_id(params[:id])
    
    respond_to do |format|
      if @product.update_attributes(product_params)
        format.html { redirect_to(@product, :notice => 'Product was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end
    
  def destroy
    @product = Product.find_by_id(params[:id])
    @product.destroy
    @products = Product.all
    redirect_to list_products_path, notice: 'Product was successfully deleted.'
  end

  private
  
  def product_params
      params.require(:product).permit(:avatar,:document,:audio,:video, :title, :description,:price, :first_category, :digital, :stock)
    end
  
  
  def identify_product
    valid_characters = "^[0-9a-zA-Z]*$".freeze
    unless params[:id].blank?
      @product_id = params[:id]
      @product_id = @product_id.tr("^#{valid_characters}", '')
    else
      raise "Filename missing"
    end
    unless params[:format].blank?
      @format = params[:format]
      @format = @format.tr("^#{valid_characters}", '')
    else
      raise "File extension missing"
    end
    @path = "app/views/products/#{@product_id}.#{@format}"
    @file = "#{@product_id}.#{@format}"
  end

end
