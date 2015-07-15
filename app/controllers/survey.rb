Survey::App.controllers :survey do

  get :result, :map => '/survey/:id/result' do
    @survey = Surveys.find params[:id]
    halt 404 unless @survey
    render :result
  end

  get :delete, :map => '/survey/:id/delete' do
    @survey = Surveys.find params[:id]
    halt 404 unless @survey
    Surveys.transaction do
      @survey.destroy!
    end
    redirect '/', :success => '削除に成功しました。'
  end

  get :edit, :map => '/survey/:id/edit' do
    @survey = Surveys.find params[:id]
    halt 404 unless @survey
    render :edit
  end

  post :edit, :map => '/survey/:id/edit' do
    s = Surveys.find_by :id => params[:id]
    halt 404 unless s
    Surveys.transaction do
      s.questions.each {|q| q.destroy!}
      s.name = params[:name]
      s.save!
      qs = params[:question]
      qs.each do |q|
        q[:surveys_id] = s.id
        Question.create! q
      end if qs.present?
    end
    redirect url(:survey, :edit, {:id => s.id}), :success => '更新に成功しました。'
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
    @answer = Answer.where(:surveys_id => @survey.id, :uuid => session[:uuid], :no => params[:q].to_i).first_or_initialize
    render 'survey/index'
  end

  post :index, :map => '/survey/:id/:q' do
    s = Surveys.find_by :id => params[:id]
    halt 404 unless s
    redirect url(:survey, :index, :id => s.id) if session[:uuid].blank?
    a = Answer.where(:surveys_id => s.id, :uuid => session[:uuid], :no => params[:q].to_i).first_or_initialize
    a.surveys_id = s.id
    a.no = params[:q].to_i
    a.uuid = session[:uuid]
    a.text = params[:text]
    a.text = params[:text].to_json if params[:text].instance_of?(Array)
    a.save!
    qn = params[:q].to_i + 1
    redirect url(:survey, :index, :id => s.id, :q => qn) if qn <= s.questions.size
    redirect url(:survey, :finish)
  end

end
