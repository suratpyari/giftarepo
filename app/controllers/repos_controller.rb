class ReposController < ApplicationController
  before_action :set_repo, only: [:show, :edit, :update, :destroy, :gift, :fork, :update_readme]

  def gift
    @repo.claims.find_by_user_id(params[:repo][:gifted_to_id]).update_column(:approved, true)
    @repo.update_column(:status, "approved")
    redirect_to :back, notice: 'A request has been sent to user to fork the repository.'
  end

  def fork
    github = Github.new oauth_token: session[:login_token]
    new_repo = github.repos.forks.create @repo.user.username, @repo.title
    @repo.update_columns({gifted_to_id: current_user.id, new_url: new_repo.html_url, status: "forked"})
    @repo.claims.destroy_all
    redirect_to :back, notice: 'The repository has been forked. It may take some time.'
  end

  def update_readme
    contents = Github::Client::Repos::Contents.new oauth_token: session[:login_token]
    readme = "#{@repo.url}/#{params[:readme]}"
    file = contents.find user: current_user.username, repo: @repo.title, path: params[:readme]
    contents.update current_user.username, @repo.title, params[:readme],
      path: params[:readme],
      message: 'Gifted to #{@repo.gifted_to.username}',
      content: "This repository is not maintained anymore. Visit the following link\n #{@repo.new_url}",
      sha: file.sha
    @repo.update_column(:status, "completed")
    redirect_to :back, notice: 'You have gifted you repository.\nThankyou.'
  end

  def index
    @repos = params[:my]=="true" ? Repo.my(current_user).page(params[:page]||1).per(5) : Repo.not_complated.page(params[:page]||1).per(5)
    @repo = Repo.new
  end

  def find_content
    repos = Github::Client::Repos.new.list user: current_user.username
    @github_repo = repos.select{|x| x.html_url == params[:url]}.first
  end

  def show
    if @repo.user != current_user
      flash[:error] = "you are not authorized to access this page"
      redirect_to :back
    end
  end

  def new
    @repo = Repo.new
  end

  def edit
  end

  def create
    @repo = current_user.repos.new(repo_params)

    respond_to do |format|
      if @repo.save
        format.html { redirect_to repos_path, notice: 'Repo was successfully created.' }
        format.json { render :show, status: :created, location: @repo }
        format.js{}
      else
        format.html { render :new }
        format.json { render json: @repo.errors, status: :unprocessable_entity }
        format.js{}
      end
    end
  end

  # PATCH/PUT /repos/1
  # PATCH/PUT /repos/1.json
  def update
    claim = @repo.claims.new(user: current_user)
    if claim.save
      redirect_to :back, notice: "Your request has been sent to owner"
    else
      flash[:error] = claim.errors.full_messages.join('\n')
      redirect_to :back
    end
  end

  # DELETE /repos/1
  # DELETE /repos/1.json
  def destroy
    @repo.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Repo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_repo
      @repo = Repo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gift_params
      params.require(:repo).permit(:gifted_to_id, :tnc)
    end

    def repo_params
      params.require(:repo).permit(:url, :title, :description, :languages, :tnc)
    end
end
