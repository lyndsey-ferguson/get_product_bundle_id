module Fastlane
  module Actions
    class GetProductBundleIdAction < Action
      require 'xcodeproj'

      def self.run(params)
        projectpath = params[:project_filepath]
        project = Xcodeproj::Project.open(projectpath)
        scheme = project.native_targets.find { |target| target.name == params[:scheme] }

        UI.user_error!("Scheme '#{params[:scheme]}' does not exist in the given project") if scheme.nil?

        if params[:target].nil?
          build_configuration = scheme.build_configurations.first
        else
          build_configuration = scheme.build_configurations.find { |target| target.name == params[:target] }

          UI.user_error!("Target '#{params[:target]}' does not exist in the given scheme") if build_configuration.nil?
        end
        build_configuration.build_settings['PRODUCT_BUNDLE_IDENTIFIER']
      end

      def self.description
        "Gets PRODUCT_BUNDLE_IDENTIFIER from a buildable target in an Xcode project using a provided scheme"
      end

      def self.authors
        ["Lyndsey Ferguson lyndsey-ferguson/ldferguson"]
      end

      def self.return_value
        "A string with the PRODUCT_BUNDLE_IDENTIFIER"
      end

      def self.details
        "Gets the PRODUCT_BUNDLE_IDENTIFIER from either a named target or the first buildable target from an Xcode project using a provided scheme."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :project_filepath,
                                  env_name: "GET_PRODUCT_BUNDLE_ID_PROJECT_PATH",
                               description: "The file path to the project file with the '.xcodeproj' file extension",
                                  optional: false,
                                      type: String,
                                      verify_block: proc do |value|
                                        UI.user_error!("Invalid project file path for GetProductBundleIdAction given, pass using `project_filepath: 'path/to/project.xcodeproj'`") if value.nil? || !Dir.exist?(value)
                                        UI.user_error!("Invalid project bundle for GetProductBundleIdAction given: missing project.pbxproj file") unless File.exist?("#{value}/project.pbxproj")
                                      end),
          FastlaneCore::ConfigItem.new(key: :scheme,
                                  env_name: "GET_PRODUCT_BUNDLE_ID_SCHEME",
                               description: "The scheme from which to retrieve the buildable target",
                                  optional: false,
                                      type: String,
                                      verify_block: proc do |value|
                                        UI.user_error!("Invalid scheme for GetProductBundleIdAction given, pass using `scheme: 'schemeName'`") if value.nil? || value.empty?
                                      end),
          FastlaneCore::ConfigItem.new(key: :target,
                                  env_name: "GET_PRODUCT_BUNDLE_ID_TARGET",
                               description: "The name of the target from which to get the PRODUCT_BUNDLE_IDENTIFIER from. If not given, defaults to the first buildable target",
                                  optional: true,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
