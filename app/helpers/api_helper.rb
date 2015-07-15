# Helper methods defined here can be accessed in any controller or view in the application

module Survey
  class App
    module ApiHelper
      ##
      # エラーレスポンス返却
      #
      def err_res v = {}, root_opt = {}
        content_type 'application/json; charset=utf-8'
        {is_success: 0}.merge(root_opt).merge({error: v}).to_json
      end
      ##
      # 正常レスポンス返却
      #
      def suc_res v = {}, root_opt = {}
        content_type 'application/json; charset=utf-8'
        {is_success: 1}.merge(root_opt).merge({results: v}).to_json
      end
    end

    helpers ApiHelper
  end
end
