class AccountsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_and_authorize, only: %i[ show edit update destroy ]

  def index
    authorize Account
    @accounts = Account.all
  end

  def show; end

  def new
    @account = Account.new
  end

  def edit; end

  def create
    @account = Account.new(nickname: account_params[:nickname], user_id: current_user.id)

    respond_to do |format|
      if @account.save
        format.html { redirect_to account_url(@account), notice: "Account was successfully created." }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to account_url(@account), notice: "Account was successfully updated." }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_url, notice: "Account was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def load_and_authorize
    @account = Account.find(params[:id])
    authorize @account
  end

  def account_params
    params.require(:account).permit(:nickname)
  end
end
