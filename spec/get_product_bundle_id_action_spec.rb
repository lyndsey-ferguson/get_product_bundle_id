describe Fastlane do
  describe Fastlane::FastFile do
    describe "get_product_bundle_id" do
      describe '#run' do
        before(:each) do
          tmpdir = Dir.mktmpdir
          @tmp_xcodeproj_dirpath = "#{tmpdir}/CoinTossing"
          FileUtils.mkdir_p(@tmp_xcodeproj_dirpath)
          xcodeproj_dirpath = File.expand_path('spec/fixtures/projects/CoinTossing/.')
          FileUtils.cp_r(xcodeproj_dirpath, tmpdir)
        end

        after(:each) do
          FileUtils.rm_rf(@tmp_xcodeproj_dirpath)
        end

        it 'throws an error when given a project file that does not exist' do
          fastfile = "lane :test do
            get_product_bundle_id(project_filepath: 'not/a/path.xcodeproj')
          end"
          expect { Fastlane::FastFile.new.parse(fastfile).runner.execute(:test) }.to(
            raise_error(FastlaneCore::Interface::FastlaneError) do |error|
              expect(error.message).to match(/Invalid project file path for GetProductBundleIdAction given/)
            end
          )
        end

        it 'throws an error when given an empty project file' do
          fastfile = "lane :test do
            get_product_bundle_id(project_filepath: '')
          end"
          expect { Fastlane::FastFile.new.parse(fastfile).runner.execute(:test) }.to(
            raise_error(FastlaneCore::Interface::FastlaneError) do |error|
              expect(error.message).to match(/Invalid project file path for GetProductBundleIdAction given/)
            end
          )
        end

        it 'throws an error when the given scheme does not exist' do
          project_path = "#{@tmp_xcodeproj_dirpath}/CoinTossing.xcodeproj"
          fastfile = "lane :test do
            get_product_bundle_id(project_filepath: '#{project_path}', scheme: 'No Scheme')
          end"
          expect { Fastlane::FastFile.new.parse(fastfile).runner.execute(:test) }.to(
            raise_error(FastlaneCore::Interface::FastlaneError) do |error|
              expect(error.message).to match("Scheme 'No Scheme' does not exist in the given project")
            end
          )
        end

        it 'throws an error when the given target does not exist' do
          project_path = "#{@tmp_xcodeproj_dirpath}/CoinTossing.xcodeproj"
          fastfile = "lane :test do
            get_product_bundle_id(project_filepath: '#{project_path}', scheme: 'CoinTossing', target: 'No Target')
          end"
          expect { Fastlane::FastFile.new.parse(fastfile).runner.execute(:test) }.to(
            raise_error(FastlaneCore::Interface::FastlaneError) do |error|
              expect(error.message).to match("Target 'No Target' does not exist in the given scheme")
            end
          )
        end

        it 'provides the PRODUCT_BUNDLE_IDENTIFIER for the first target in the scheme' do
          project_path = "#{@tmp_xcodeproj_dirpath}/CoinTossing.xcodeproj"
          fastfile = "lane :test do
            get_product_bundle_id(project_filepath: '#{project_path}', scheme: 'CoinTossing')
          end"
          result = Fastlane::FastFile.new.parse(fastfile).runner.execute(:test)
          expect(result).to eq("Test.CoinTossing")
        end

        it 'provides the PRODUCT_BUNDLE_IDENTIFIER for the named target in the scheme' do
          project_path = "#{@tmp_xcodeproj_dirpath}/CoinTossing.xcodeproj"
          fastfile = "lane :test do
            get_product_bundle_id(project_filepath: '#{project_path}', scheme: 'CoinTossingUITests', target: 'Release')
          end"
          result = Fastlane::FastFile.new.parse(fastfile).runner.execute(:test)
          expect(result).to eq("Test.CoinTossingUITests.Release")
        end
      end
    end
  end
end
