Survey::App.controllers :survey do

  get :result, :map => '/survey/:id/result' do
    @survey = Surveys.find_by(:id => params[:id]) or halt 404
    halt 404 if @survey.is_secret && @survey.hash_key != params[:hash_key]
    render :result
  end

  get :delete, :map => '/survey/:id/delete' do
    @survey = Surveys.find_by(:id => params[:id]) or halt 404
    halt 404 if @survey.is_secret && @survey.hash_key != params[:hash_key]
    Surveys.transaction do
      @survey.destroy!
    end
    redirect url('/'), :success => '削除に成功しました。'
  end

  get :edit, :map => '/survey/:id/edit' do
    @survey = Surveys.find_by(:id => params[:id]) or halt 404
    halt 404 if @survey.is_secret && @survey.hash_key != params[:hash_key]
    render :edit
  end

  post :edit, :map => '/survey/:id/edit' do
    @survey = Surveys.eager_load(:questions).find_by(:id => params[:id]) or halt 404
    halt 404 if @survey.is_secret && @survey.hash_key != params[:hash_key]
    begin
      Surveys.transaction do
        @survey.questions.destroy_all
        @survey.name = params[:name]
        @survey.is_secret = params[:is_secret] == 'true' ? true : false
        @survey.questions.build(params[:question] || [])
        @survey.save!
      end
      par = {:id => @survey.id}
      par[:hash_key] = @survey.hash_key if @survey.is_secret
      redirect url(:survey, :edit, par), :success => '更新に成功しました。'
    rescue
      render :edit
    end
  end

  get :finish do
    render 'survey/finish'
  end

  get :index, :with => :id do
    s = Surveys.find_by :id => params[:id]
    halt 404 unless s
    session[:uuid] = SecureRandom.uuid if session[:uuid].blank?
    redirect url(:survey, :index, :id => s.id, :q => 1)
  end

  get :index, :map => '/survey/:id/:q' do
    @survey = Surveys.find_by :id => params[:id]
    halt 404 unless @survey
    @question = @survey.questions[params[:q].to_i - 1]
    halt 404 unless @question
    redirect url(:survey, :index, :id => @survey.id) if session[:uuid].blank?
    @answer = Answer.where(:surveys_id => @survey.id, :uuid => session[:uuid], :no => params[:q].to_i).first_or_initialize
    render 'survey/index'
  end

  post :index, :map => '/survey/:id/:q' do
    s = Surveys.find_by :id => params[:id]
    halt 404 unless s
    redirect url(:survey, :index, :id => s.id) if session[:uuid].blank?
    a = Answer.where(:surveys_id => s.id, :uuid => session[:uuid], :no => params[:q].to_i).first_or_initialize
    a.surveys_id = s.id
    q = s.questions[params[:q].to_i - 1]
    a.no = params[:q].to_i
    a.uuid = session[:uuid]
    a.text = params[:text] if q.single? || q.free?
    a.text = params[:text].to_json if q.multiple?
    if q.date?
      t = {}
      q.each_date.each do |d|
        t[d] = params[d]
      end
      a.text = {
        :name    => params[:name],
        :comment => params[:comment],
        :date    => t,
      }.to_json
    end
    a.save!
    qn = params[:q].to_i + 1
    redirect url(:survey, :index, :id => s.id, :q => qn) if qn <= s.questions.size
    redirect url(:survey, :finish)
  end

end
