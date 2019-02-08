platform :ios, '10.0'
use_frameworks!
def main_sources
#define your pod resources
pod 'Alamofire'
pod 'ARCL'
pod 'SDWebImage', '~> 4.0'

end
def test_sources
#define your pod resources for unit test

end
target 'NeonStreet' do
main_sources

  target 'NeonStreetTests' do
    inherit! :search_paths
    test_sources
  end

  target 'NeonStreetUITests' do
    inherit! :search_paths
    test_sources
  end

end