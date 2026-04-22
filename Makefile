watch:
	fvm flutter pub run build_runner watch --delete-conflicting-outputs

get:
	fvm flutter clean && fvm flutter pub get

apk_dev:
	fvm flutter build apk --no-shrink

apk:
	fvm flutter build apk --no-shrink --dart-define=DART_DEFINES_ENV="prod" --dart-define=DART_DEFINES_URL=""

aab:
	fvm flutter build appbundle --no-shrink --dart-define=DART_DEFINES_ENV="prod" --dart-define=DART_DEFINES_URL=""

ipa:
	fvm flutter build ipa --release --dart-define=DART_DEFINES_ENV="prod" --dart-define=DART_DEFINES_URL=""

run:
	fvm dart run build_runner build --delete-conflicting-outputs 

clean:
	fvm flutter clean && fvm flutter pub get && fvm dart run build_runner build --delete-conflicting-outputs

rm:
	fvm flutter clean && fvm flutter pub get && rm -rf ios/Pods ios/Podfile.lock && cd ios && pod install
