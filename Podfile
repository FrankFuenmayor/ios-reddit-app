target 'RedditTop' do
    use_frameworks!
    pod 'AFNetworking'
end

target 'RedditTopTests' do
    use_frameworks!
    pod 'AFNetworking'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

