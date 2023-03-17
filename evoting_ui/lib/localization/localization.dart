import 'package:get/get.dart';

class Localization extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'auth_title': 'VOTER AUTHENTICATION',
          'selection': 'Please Select Language',
          'citizenship': 'Enter Your Citizenship Number',
          'voterId': 'Enter Your Voter-ID',
          'alert': 'Alert!',
          'auth': 'Authenticate',
          'auth_fail': 'VOTER AUTHENTICATION FAILED',
          'field_empty': 'The Citizenship or VoterID field is empty',
          'c_invalid': 'The entered citizenshipID is invalid',
          'v_invalid': 'VoterID length should be 6 Digits',
          'bio_title': 'BIOMETRIC VERIFICATION PHASE',
          'press': 'Please press the biometric sensor',
          'time_left': 'Time left to press biometric Sensor',
          'press_again': 'Please press the sensor again',
          'voting_screen': 'VOTING SCREEN FOR MAYOR',
          'voting_screen_sub': 'VOTING SCREEN FOR DEPUTY-MAYOR',
          'confirm_vote': 'Confirm Vote?',
          'photo_candidate': 'Photo Of Candidate: ',
          'party_symbol': 'Party Symbol Of Candidate:',
          'vote': 'VOTE',
          'voting_end': 'Voting process is over',
          'confirmation':
              'By pressing the tick button you will vote for this candidate and will not be able to undo the voting. You can select other candidate by selecting the cancel option',
          'end_screen': 'VOTING PROCESS ENDED'
        },
        'np_NP': {
          'auth_title': 'मतदाता प्रमाणीकरण',
          'selection': 'कृपया भाषा चयन गर्नुहोस्',
          'citizenship': 'आफ्नो नागरिकता नम्बर प्रविष्ट गर्नुहोस्',
          'voterId': 'आफ्नो मतदाता परिचय पत्र प्रविष्ट गर्नुहोस्',
          'alert': 'अलर्ट',
          'auth': 'प्रमाणीकरण गर्नुहोस्',
          'auth_fail': 'मतदाता प्रमाणीकरण असफल भयो',
          'field_empty': 'नागरिकता वा मतदाता परिचयपत्र फिल्ड खाली छ',
          'c_invalid': 'प्रविष्ट गरिएको नागरिकता आईडी अमान्य छ',
          'v_invalid': 'मतदाता परिचयपत्रको लम्बाइ ६ अंकको हुनुपर्छ',
          'bio_title': 'बायोमेट्रिक प्रमाणीकरण चरण',
          'press': 'कृपया बायोमेट्रिक सेन्सर थिच्नुहोस्',
          'time_left': 'बायोमेट्रिक सेन्सर थिच्न समय बाँकी छ',
          'press_again': 'कृपया सेन्सर फेरि थिच्नुहोस्',
          'voting_screen': 'मेयरका लागि भोटिङ स्क्रिन',
          'voting_screen_sub': 'उपमेयरका लागि भोटिङ स्क्रिन',
          'confirm_vote': 'भोट पुष्टि गर्ने?',
          'photo_candidate': 'उम्मेदवारको फोटो:',
          'party_symbol': 'उम्मेदवारको पार्टी चिन्ह:',
          'vote': 'भोट',
          'voting_end': 'मतदान प्रक्रिया सकियो',
          'confirmation':
              'टिक बटन थिचेर तपाईंले यस उम्मेदवारलाई भोट गर्नुहुनेछ र मतदानलाई पूर्ववत गर्न सक्षम हुनुहुने छैन। तपाईं रद्द विकल्प चयन गरेर अन्य उम्मेद्वार चयन गर्न सक्नुहुन्छ',
          'end_screen': 'भोटिङ प्रक्रिया समाप्त भयो'
        }
      };
}
