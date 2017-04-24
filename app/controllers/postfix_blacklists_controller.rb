class PostfixBlacklistsController < ApplicationController
  before_action :set_postfix_blacklist, only: [:show, :edit, :update, :destroy]

  # GET /postfix_blacklists
  # GET /postfix_blacklists.json
  def index
    @postfix_blacklists = PostfixBlacklist.accessible_by(current_ability)
    authorize! :read, PostfixBlacklist
  end


  # GET /postfix_blacklists/new
  def new
    @postfix_blacklist = PostfixBlacklist.new
    authorize! :read, @postfix_blacklist
  end

  # GET /postfix_blacklists/1/edit
  def edit
    authorize! :update, @postfix_blacklist
  end

  # POST /postfix_blacklists
  # POST /postfix_blacklists.json
  def create
    @postfix_blacklist = PostfixBlacklist.new(postfix_blacklist_params)
    authorize! :create, @postfix_blacklist

    respond_to do |format|
      if @postfix_blacklist.save
        format.html { redirect_to postfix_blacklists_path, notice: 'Postfix blacklist was successfully created.' }
        format.json { render :show, status: :created}
      else
        format.html { render :new }
        format.json { render json: @postfix_blacklist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /postfix_blacklists/1
  # PATCH/PUT /postfix_blacklists/1.json
  def update
    authorize! :update, @postfix_blacklist
    respond_to do |format|
      if @postfix_blacklist.update(postfix_blacklist_params)
        format.html { redirect_to postfix_blacklists_path, notice: 'Postfix blacklist was successfully updated.' }
        format.json { render :show, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @postfix_blacklist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /postfix_blacklists/1
  # DELETE /postfix_blacklists/1.json
  def destroy
    authorize! :destroy, @postfix_blacklist
    @postfix_blacklist.destroy
    respond_to do |format|
      format.html { redirect_to postfix_blacklists_url, notice: 'Postfix blacklist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_postfix_blacklist
      @postfix_blacklist = PostfixBlacklist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def postfix_blacklist_params
      params.require(:postfix_blacklist).permit(:email, :reject_text, :commentary)
    end
end
