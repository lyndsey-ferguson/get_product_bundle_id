module Fastlane
  module Actions
    class GetProductBundleIdAction < Action
      require 'xcodeproj'

      def self.run(params)
        projectpath = params[:project_filepath]
        scheme = xcscheme(params)
        target_uuids = scheme.build_action.entries.first.buildable_references.map(&:target_uuid)

        project = Xcodeproj::Project.open(projectpath)
        targets = project.targets.find_all { |t| target_uuids.include?(t.uuid) }
        if params[:target].nil?
          build_configuration = xcbuildconfiguration(targets.first, params[:build_configuration])
        else
          target = targets.find { |t| t.name == params[:target] }

          UI.user_error!("Target '#{params[:target]}' does not exist in the given scheme") if target.nil?

          build_configuration = xcbuildconfiguration(target, params[:build_configuration])
        end
        build_configuration.build_settings['PRODUCT_BUNDLE_IDENTIFIER']
      end

      def self.xcscheme(params)
        projectpath = params[:project_filepath]

        scheme_paths = Dir.glob("#{projectpath}/xcshareddata/xcschemes/#{params[:scheme]}.xcscheme")
        if scheme_paths.empty?
          scheme_paths = Dir.glob("#{projectpath}/xcuserdata/xcschemes/#{params[:scheme]}.xcscheme")
        end
        UI.user_error!("Scheme '#{params[:scheme]}' does not exist in the given project") if scheme_paths.empty?

        scheme_path = scheme_paths.first
        Xcodeproj::XCScheme.new(scheme_path)
      end

      def self.xcbuildconfiguration(target, build_configuration_name)
        if build_configuration_name.nil?
          configuration = target.build_configurations.first
        
          UI.message("No configuration specified, taking first: '#{configuration.name}'")
        else
          configuration = target.build_configurations.find { |c| c.name == build_configuration_name }

          UI.user_error!("Build configuration '#{build_configuration_name}' does not exist in target '#{target.name}'") if configuration.nil?
        end
        configuration
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
          FastlaneCore::ConfigItem.new(key: :build_configuration,
                                  env_name: "GET_PRODUCT_BUNDLE_ID_BUILD_CONFIGURATION",
                               description: "The name of the build configuration to use. If not given, defaults to the first build configuration",
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
