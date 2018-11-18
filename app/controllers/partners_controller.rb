class PartnersController < ApplicationController
  before_action :set_partner, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_partner!

  # GET /partners
  # GET /partners.json
  def index
    @partners = Partner.all
    authorize @partners
  end

  # GET /partners/1
  # GET /partners/1.json
  def show; end

  # GET /partners/new
  def new
    @partner = Partner.new
  end

  # GET /partners/1/edit
  def edit; end

  def approve
    @partner = Partner.find(params[:partner_id])
    @partner.approve_me
    redirect_to @partner, notice: "You have submitted your details for approval."
  end

  # POST /partners
  # POST /partners.json
  def create
    @partner = Partner.new(partner_params)

    respond_to do |format|
      if @partner.save
        format.html { redirect_to @partner, notice: "Partner was successfully created." }
        format.json { render :show, status: :created, location: @partner }
      else
        format.html { render :new }
        format.json { render json: @partner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /partners/1
  # PATCH/PUT /partners/1.json
  def update
    respond_to do |format|
      if @partner.update(partner_params)
        format.html { redirect_to @partner, notice: "Details were successfully updated." }
        format.json { render :show, status: :ok, location: @partner }
      else
        format.html { render :edit }
        format.json { render json: @partner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /partners/1
  # DELETE /partners/1.json
  def destroy
    @partner.destroy
    respond_to do |format|
      format.html { redirect_to partners_url, notice: "Partner was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  # NOTE(chaserx): pundit let's us authorize partner specific actions here as a
  #  convenience rather than in each of the partner specific methods
  def set_partner
    @partner = authorize Partner.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def partner_params
    params.require(:partner).permit(
      :name,
      :agency_type,
      :partner_status,
      :proof_of_partner_status,
      :agency_mission,
      :address1,
      :address2,
      :city,
      :state,
      :zip_code,
      :website,
      :facebook,
      :twitter,
      :founded,
      :form_990,
      :proof_of_form_990,
      :program_name,
      :program_description,
      :program_age,
      :case_management,
      :evidence_based,
      :evidence_based_description,
      :program_client_improvement,
      :diaper_use,
      :other_diaper_use,
      :currently_provide_diapers,
      :turn_away_child_care,
      :program_address1,
      :program_address2,
      :program_city,
      :program_state,
      :program_zip_code,
      :max_serve,
      :incorporate_plan,
      :responsible_staff_position,
      :storage_space,
      :describe_storage_space,
      :trusted_pickup,
      :income_requirement_desc,
      :serve_income_circumstances,
      :income_verification,
      :internal_db,
      :maac,
      :population_black,
      :population_white,
      :population_hispanic,
      :population_asian,
      :population_american_indian,
      :population_island,
      :population_multi_racial,
      :population_other,
      :zips_served,
      :at_fpl_or_below,
      :above_1_2_times_fpl,
      :greater_2_times_fpl,
      :poverty_unknown,
      :ages_served,
      :executive_director_name,
      :executive_director_phone,
      :executive_director_email,
      :program_contact_name,
      :program_contact_phone,
      :program_contact_mobile,
      :program_contact_email,
      :pick_up_method,
      :pick_up_name,
      :pick_up_phone,
      :pick_up_email,
      :distribution_times,
      :new_client_times,
      :more_docs_required,
      :sources_of_funding,
      :sources_of_diapers,
      :diaper_budget,
      :diaper_funding_source,
      documents: []
    )
  end

  # NOTE(chaserx): the is required for pundit since our auth'd user is named `partner`
  def pundit_user
    current_partner
  end
end
