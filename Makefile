
watch:
	fvm flutter pub run build_runner watch fvm flutter pub run build_runner watch --delete-conflicting-outputs

get:
	flutter clean && flutter pub get

apk_dev:
	flutter build apk --no-shrink

apk:
	flutter build apk --no-shrink --dart-define=DART_DEFINES_ENV="prod" --dart-define=DART_DEFINES_URL=""

aab:
	flutter build appbundle --no-shrink --dart-define=DART_DEFINES_ENV="prod" --dart-define=DART_DEFINES_URL=""

ipa:
	flutter build ipa --release --dart-define=DART_DEFINES_ENV="prod" --dart-define=DART_DEFINES_URL=""

run:
	dart run build_runner build --delete-conflicting-outputs 

clean:
	flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs

rm:
	flutter clean && flutter pub get && rm -rf ios/Pods ios/Podfile.lock && cd ios && pod install
