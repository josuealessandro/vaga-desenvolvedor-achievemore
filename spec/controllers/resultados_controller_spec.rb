require 'rails_helper'

RSpec.describe ResultadosController, type: :controller do
  let(:arquivo_valido) { { file: fixture_file_upload('metas_validas.csv', 'text/csv') } }

  let(:cliente) {
    create(:cliente)
  }

  let(:valid_attributes) {
    { cliente_id: cliente.id, periodo: Date.today, valor_meta: 10, valor_realizado: 12 }
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      resultado = Resultado.create! valid_attributes
      get :index, params: {}, session: valid_session
      json_response = JSON.parse(response.body)

      expect(response).to be_successful
      expect(json_response['resultados']).to include(JSON.parse(resultado.to_json))
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      resultado = Resultado.create! valid_attributes
      get :show, params: {id: resultado.to_param}, session: valid_session
      json_response = JSON.parse(response.body)

      expect(response).to be_successful
      expect(json_response['resultado']).to include(JSON.parse(resultado.to_json))
    end

    it "returns not a success response" do
      get :show, params: {id: 99}, session: valid_session

      expect(response).not_to be_successful
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Resultado" do
        expect {
          post :create, params: {resultado: valid_attributes}, session: valid_session
        }.to change(Resultado, :count).by(1)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {valor_realizado: 15}
      }

      it "updates the requested resultado" do
        resultado = Resultado.create! valid_attributes

        put :update, params: {id: resultado.to_param, resultado: new_attributes}, session: valid_session

        resultado.reload

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
        expect(json_response['location']).to include(JSON.parse(resultado.to_json))
        expect(resultado.valor_realizado).to eq(15)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested resultado" do
      resultado = Resultado.create! valid_attributes
      expect {
        delete :destroy, params: {id: resultado.to_param}, session: valid_session
      }.to change(Resultado, :count).by(-1)
    end
  end

  describe "Teste final!" do
    it "qual a resposta para a vida o universo e tudo mais?" do
      resposta = Base64.encode64("42")
      expect("NDI=\n").to eq(resposta)
    end
  end
end
