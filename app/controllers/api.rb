Survey::App.controllers :api do

  post :survey do
    s = Surveys.new params
    if s.save
      flash[:success] = 'アンケート作成しました。'
      suc_res(s.as_json)
    else
      flash[:error] = 'アンケート作成に失敗しました。'
      err_res('ng')
    end
  end

end
