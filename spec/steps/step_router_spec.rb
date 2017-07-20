# frozen_string_literal: true

RSpec.describe StepRouter do
  describe '#call' do
    let(:env) do
      {
        'REQUEST_METHOD' => 'GET',
        'action_dispatch.request.path_parameters' => {
          __step_name__: 'introduction-introduce-yourself'
        }
      }
    end

    let(:step_router) do
      described_class.new(env)
    end

    it 'calls the controller action if a controller is found' do
      action = double('action')

      allow(IntroductionIntroduceYourselfController).to receive(:action)
        .with(:edit)
        .and_return(action)

      expect(action).to receive(:call).with(env)

      step_router.call
    end

    it 'returns a 404 if no controller is found' do
      env['action_dispatch.request.path_parameters'][:__step_name__] = '123foo'
      expect(step_router.call).to eq([404, { 'X-Cascade' => 'pass' }, []])
    end

    it 'returns a 404 if a bad request action is passed' do
      env['REQUEST_METHOD'] = '123foo'
      expect(step_router.call).to eq([404, { 'X-Cascade' => 'pass' }, []])
    end
  end
end
