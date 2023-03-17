// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:developer';
import './sub_mayor_selection.dart';
import 'package:flutter/material.dart';
import '../models/candidate_get.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class SubMayorVotingView extends StatefulWidget {
  String token = '';
  // String localizationString;
  List<CandidateGet> subMayor;
  String encryptedVote = '';
  SubMayorVotingView(this.token, this.subMayor, this.encryptedVote);

  @override
  State<SubMayorVotingView> createState() => _VotingViewState();
}

class _VotingViewState extends State<SubMayorVotingView> {
  int optionSelected = 0;
  bool isSubmitted = false;
  String url = '100.215';
  int postID = 0;
  String year = '';

  // List<CandidateGet> _candidatesMayor = [
  //   CandidateGet(
  //       candidateFirstName: "Subash",
  //       candidateId: 1,
  //       candidateLastName: "shakya",
  //       candidatePartyName: "UML",
  //       candidatePartySymbol:
  //           "UklGRp4MAABXRUJQVlA4WAoAAAAIAAAAZwEAZwEAVlA4IL4LAADQXQCdASpoAWgBPm02lUekIyIhKdQYSIANiWlu7mB0FcuekyvlTdAu/Tv8z/g/CD+8/5/uv+0juYXz53Hl/3jfzvfDvGf6Z/jPaqefOAu6vqAfW+aOlunkf9rzynrMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMxafqGI9Lek6hMzMzMzMzMzMU9gmxzlHewcvPK78aXxrnk38VcRWZ8uqqqqqqqoXAYbYG6lQXJVmQAhFUQBNu+DDqgABIQKVVVVVVVTtNSHy+hhmMzMm88tENzdVVVVVVVVIoTLh/01e3o7u5+lSoyYO7JB0xMFd/W656Gfm0K5lmZmZmZYySZ0t+q8B1NBP1jDSnvPZmZmZmOlhHMbqoa2K13d6dtykFMBYJwvAeB28B27u7u7u7O5sioKNXbVFy/nUWB1TDD2wNCDua4lrDbu7u7uwtx28Fwrm74YnGsiTRfFhmZmZmZeRMKWd1z5jT5B0df29/kc+9aFCK3bE3/HTwO6qqqqqqqqhoppRUBN/yqH3Dq5n5PTLzyS8nVu7u7u7u7uwfv6a0eqZXsD12ARHjOYPI/vNJKUZ0JhdhKqn2Lu7u7u7C9lUGffKJPzNoFEGa/6MemHkQBUUvcZgqsRGxiPp3VKYn6s/qmcMjWmZlVG+XLVX+4rRZyJNtM4DCSGbCRbCgm1878GVGpSon2ayf5ukMAsBPeeMfVDqRrYL8dIf5auaTzKOjUbIHenPiI4kWFfzO5px3/l7LimjklOGYQzN2d3lYCdo0Q8Stnb1xEapmHc0rSzIAvX2pZTB8nbBT5vy1JeVTskLl+Zy9+Qv4ywDm5/tpjfzpA7jLa2P9lgm8U478Ywh05NKQ/+L2EYVdp6JPPM9Xkz+T5CzEnRCcgfGyarVm2JgK3WX8OuzuTUuVkhyoCJ4wd6pCuRfbLqkEmkYIB/D0CWKQPVASxgYFrp6dT08OZYaTZC0MoJO4pA766b08Hd3d3d3d3d3d3d3d3d3d3d3d3d3d3d14AA/vXPABA7XBirw+VhFVP/nMfgXjuyCAGb/T0Ctv6p7JLlut++RylYNS7zvZR5GnVpB/F+GNKmkiMi205ffN2MeYO5Vz9j73dB4w6gLFAeQ4mETjHNeCQaeMbdhVLw2sSgiu5p1GKa8/Esg4li8vbbys50aZsm6Uq/n0aGrlwW+54ptSaHPKlQO6ml4TBYcM3eS8HL3r9vUmpY4JH7QYZRfeQTGqUAyNhHLS+vEqHkknSTazGSEL9Qrlk5+fC6uzjOIOtLdGqdnXccC7Ie9xmpUvMfpojtsyL8oeYbIGezWjMP6tl6/mudKsjRTBv6+ceMkTKMwUtEq9TXZTwm2Ntn4MJC+JlubCWTC0s/H4KcfIFrBeUtOVvadSOiZrMHo4EmLF7yc04OL6wSI1hpJNR3etJqE/KgAwCzOpUNINADL3VVWibVLovBf1Lg0+itlxfgAHc25/pm9IikIcALG/tvZgJaK4ku1yg48jO5h2NNxjHXPYI9osUCGXzNoeMF0sJQFcCO3v1cu2fMFz93ReLAHH/UO287VZT/VzFBrBMIfjYqYJm45rICmbfsko6a8sDnPXQihsJkpLwAc9wnpM88lNXQ0nbTRVt1YBr2j+829pGbbx2opD+WzOuQIoWojydsWz5XYAkG02RtitJJHrlg4xbNJBviMYbt/f7f73pJsDAvOOTbl7OSfY2RvXm9opgIaQvJETdwjxXyA7i3FnJyDFTOHF2ZblAVOYc9YIzJmPEbRXJf+g4N1xCI5C73CeymJJzKf2ZpeMTA2CPtroiPYsn1AwVqd7ng12xxxDf69yLAjn4b4hJBLDGyz8qU1x0iA5GXCrPU8OKEq15VKrY7vb8vPIisrhvRrDcBxWFmjdrDp2fcf+aj4JLQKk7FWOJTAAv14zSwGD4BA0Ulm9L8ShMthhyCPRrymJIVpDzKO/eOSQgqU28ApyfU3oInZj9LSaVwLGVZvrCK+fMYzhQFn5sE3IRGl6uR7vp/DYnXNKC5BaRY9X+cmSiCSPq0SLeZMo16x2XkTwbgkkH9keuoky+bmZWZrqhbAqY80aQDD05XlWXH6eVgyXAeEBAMHxXl36HznZt7dtTLH5fUH0RnjyLrD1a9tGRebe479iZ+MNx76cqZCoXrZ2XTtJw7Sul8rhRL8BAqbRivRS/V4V0bxdChlZ2EsGTpM52oh7X8ucggfFj5rKtcSbvDIo+thx9LNQnP3bDEBBHKMCT4tFJzteuuDBWKxv94jJ9SZEIHc1PhLPYcgWk19ClYNS4Tb6WB6Vwugt4OYaj0iCbEMy5oXCHt3lNOiokZ5Bb3ZSTWl68fndaTXHVT86QB14EbflPo823T7fFcsZgcELd0XQspTRIdJDoNoE4Pcgkol0e6YOc5RGZ5+Ti3Rg8NzzAknDyLS71kw8v90U16FBtDEAKYaK2H3ayviTR4gaoDje+4avBQ0K+op5/mI+jMNrmoV4dsSLOVC0hDw4VeNEdjykWtsMxkzLWSz0QGM8yp2Or4dj9McWftNI7RizKXsGVby3bQLwLk1sScsGWTpGp7T0EXcmi8JBptERyTSdDwHUoR2QkKBdPgR62byHPY5vBcnR0JM3jEesJCeRmliD4LNKK+fwjQkWgFG6MlTE6zyXqdsxtz3asr4bHyRdHV8M3e/Z3ZjMi6vrT0YCZ4sXRXONWbk14Oa8E9tS+//FCAWmjX8NPa8Zt4PNi9LtGJVWLMDRud+B7J7LnBxdPg5dFT271uxWHH/l4FmzlRB15TNa7HPMsiOkxi7XnajycAYWv5hTi/UvOLeidpgQu45a5pempJ2+nd2Vv6bS4TuG77T41l1xJjv07roLLt6v0Wv9NKfJJyeliZiMZ3TH4dH5WMNpcYf7jBYy/lbkXnV1TQg8q1S+W49sqmu5JRxBE0ut+pm2k71EgYKJgDA9kAIEnuXtqlyYkRlnKaKGwx3OyFP4FnwfmthStRaXL4aD3lw4Yz2Os4j68pKUFajH21LfWXU84DbZWBfWVQOM2nCARW64QeRy9ebJ9nlsrD+Lv/DHEDUCQcIgugNeyC76+/neX7cstouY7nZE86+IryBESSGdnV397DAQ841tFQ55q7T8n1N34pguVEADRo1Vn6itiVHdjzL8pmTYMLxlsE87tYNR9gJdkjru7nOKFSm/JZT5RAnrc4LqmzhQB8p0YqGAYuQpkSb9r3KaDgVgVsUvP8kgZ9zN0JRRCrmTQl/aYmc6K/zkceaBEeIayijCpBZkQJqSnMOaa3qlHqgU4S+pe4iRHRk32SlUHLjAdEadUQidQyqe0cyzielnoaoQeMHNufiWn4agcIRFZY7LVAkTO4iZ14d7vvzcnbiSaTb3ynEydnebw3TuIrSEI6YZjFPR+UQIZcDNiH9IOF86+XUe4jLDJahZqif3JCknw17ezJOKXoV97+PTEnSlu5QVoGoM3/N+tJ+nF4CpoU9SiT8zMIrM9Isww5pSd6eNUfr506IgmqMXPysFN4SVLNjONzmC6tpVCcL3EvWs4nCUFjj/QMuPQiNqls4jig75/H9xKSopgTr3/5vI8aLbaj7kE4S6QaupZvEJzVgfCfrAq81yW+anospHBdTSEn4ftA9CDZ69SKrdlRJoIOyzmve2wYaCLHnBooyhSuiuq3DeFgg0fD3yHKp7s/f2cDMB7VttQFcjbnGzfOSOqRMv+Rzut4nyzMW/G5n3FkbOq9Voe9lWMHJ66j4cH7r6FmZPY9PX+aNTyzBrBnSl2gcZv6GpwGwD3aJs14IUBisq0XNSJlEtmN3LWf/q1h4IDyGqNNc5malwdTDvj1gj5DxFT3XX/YR73ZpDqz5I9cTTlv/FDJ/aFy0/1lOzS1G0jjtql7/ZHdubaBmhinIkJBQH3tjBsRYA2ZKdnCAo0hoY5JfECAiw3nUdBJ8dlSK4J22EER4ac7KdhcrXiS6c457y9b48+XCCTo02Fb7ld+Z2Xm3FxlC3wIrWLUAYdzOAAAAABFWElGugAAAEV4aWYAAElJKgAIAAAABgASAQMAAQAAAAEAAAAaAQUAAQAAAFYAAAAbAQUAAQAAAF4AAAAoAQMAAQAAAAIAAAATAgMAAQAAAAEAAABphwQAAQAAAGYAAAAAAAAASAAAAAEAAABIAAAAAQAAAAYAAJAHAAQAAAAwMjEwAZEHAAQAAAABAgMAAKAHAAQAAAAwMTAwAaADAAEAAAD//wAAAqAEAAEAAABoAQAAA6AEAAEAAABoAQAAAAAAAA==",
  //       candidatePhoto:
  //           "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",
  //       nominatedYear: "2079"),
  //   CandidateGet(
  //       candidateFirstName: "NItish",
  //       candidateId: 2,
  //       candidateLastName: "sharma",
  //       candidatePartyName: "Congress",
  //       candidatePartySymbol:
  //           "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",
  //       candidatePhoto:
  //           "UklGRp4MAABXRUJQVlA4WAoAAAAIAAAAZwEAZwEAVlA4IL4LAADQXQCdASpoAWgBPm02lUekIyIhKdQYSIANiWlu7mB0FcuekyvlTdAu/Tv8z/g/CD+8/5/uv+0juYXz53Hl/3jfzvfDvGf6Z/jPaqefOAu6vqAfW+aOlunkf9rzynrMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMxafqGI9Lek6hMzMzMzMzMzMU9gmxzlHewcvPK78aXxrnk38VcRWZ8uqqqqqqqoXAYbYG6lQXJVmQAhFUQBNu+DDqgABIQKVVVVVVVTtNSHy+hhmMzMm88tENzdVVVVVVVVIoTLh/01e3o7u5+lSoyYO7JB0xMFd/W656Gfm0K5lmZmZmZYySZ0t+q8B1NBP1jDSnvPZmZmZmOlhHMbqoa2K13d6dtykFMBYJwvAeB28B27u7u7u7O5sioKNXbVFy/nUWB1TDD2wNCDua4lrDbu7u7uwtx28Fwrm74YnGsiTRfFhmZmZmZeRMKWd1z5jT5B0df29/kc+9aFCK3bE3/HTwO6qqqqqqqqhoppRUBN/yqH3Dq5n5PTLzyS8nVu7u7u7u7uwfv6a0eqZXsD12ARHjOYPI/vNJKUZ0JhdhKqn2Lu7u7u7C9lUGffKJPzNoFEGa/6MemHkQBUUvcZgqsRGxiPp3VKYn6s/qmcMjWmZlVG+XLVX+4rRZyJNtM4DCSGbCRbCgm1878GVGpSon2ayf5ukMAsBPeeMfVDqRrYL8dIf5auaTzKOjUbIHenPiI4kWFfzO5px3/l7LimjklOGYQzN2d3lYCdo0Q8Stnb1xEapmHc0rSzIAvX2pZTB8nbBT5vy1JeVTskLl+Zy9+Qv4ywDm5/tpjfzpA7jLa2P9lgm8U478Ywh05NKQ/+L2EYVdp6JPPM9Xkz+T5CzEnRCcgfGyarVm2JgK3WX8OuzuTUuVkhyoCJ4wd6pCuRfbLqkEmkYIB/D0CWKQPVASxgYFrp6dT08OZYaTZC0MoJO4pA766b08Hd3d3d3d3d3d3d3d3d3d3d3d3d3d3d14AA/vXPABA7XBirw+VhFVP/nMfgXjuyCAGb/T0Ctv6p7JLlut++RylYNS7zvZR5GnVpB/F+GNKmkiMi205ffN2MeYO5Vz9j73dB4w6gLFAeQ4mETjHNeCQaeMbdhVLw2sSgiu5p1GKa8/Esg4li8vbbys50aZsm6Uq/n0aGrlwW+54ptSaHPKlQO6ml4TBYcM3eS8HL3r9vUmpY4JH7QYZRfeQTGqUAyNhHLS+vEqHkknSTazGSEL9Qrlk5+fC6uzjOIOtLdGqdnXccC7Ie9xmpUvMfpojtsyL8oeYbIGezWjMP6tl6/mudKsjRTBv6+ceMkTKMwUtEq9TXZTwm2Ntn4MJC+JlubCWTC0s/H4KcfIFrBeUtOVvadSOiZrMHo4EmLF7yc04OL6wSI1hpJNR3etJqE/KgAwCzOpUNINADL3VVWibVLovBf1Lg0+itlxfgAHc25/pm9IikIcALG/tvZgJaK4ku1yg48jO5h2NNxjHXPYI9osUCGXzNoeMF0sJQFcCO3v1cu2fMFz93ReLAHH/UO287VZT/VzFBrBMIfjYqYJm45rICmbfsko6a8sDnPXQihsJkpLwAc9wnpM88lNXQ0nbTRVt1YBr2j+829pGbbx2opD+WzOuQIoWojydsWz5XYAkG02RtitJJHrlg4xbNJBviMYbt/f7f73pJsDAvOOTbl7OSfY2RvXm9opgIaQvJETdwjxXyA7i3FnJyDFTOHF2ZblAVOYc9YIzJmPEbRXJf+g4N1xCI5C73CeymJJzKf2ZpeMTA2CPtroiPYsn1AwVqd7ng12xxxDf69yLAjn4b4hJBLDGyz8qU1x0iA5GXCrPU8OKEq15VKrY7vb8vPIisrhvRrDcBxWFmjdrDp2fcf+aj4JLQKk7FWOJTAAv14zSwGD4BA0Ulm9L8ShMthhyCPRrymJIVpDzKO/eOSQgqU28ApyfU3oInZj9LSaVwLGVZvrCK+fMYzhQFn5sE3IRGl6uR7vp/DYnXNKC5BaRY9X+cmSiCSPq0SLeZMo16x2XkTwbgkkH9keuoky+bmZWZrqhbAqY80aQDD05XlWXH6eVgyXAeEBAMHxXl36HznZt7dtTLH5fUH0RnjyLrD1a9tGRebe479iZ+MNx76cqZCoXrZ2XTtJw7Sul8rhRL8BAqbRivRS/V4V0bxdChlZ2EsGTpM52oh7X8ucggfFj5rKtcSbvDIo+thx9LNQnP3bDEBBHKMCT4tFJzteuuDBWKxv94jJ9SZEIHc1PhLPYcgWk19ClYNS4Tb6WB6Vwugt4OYaj0iCbEMy5oXCHt3lNOiokZ5Bb3ZSTWl68fndaTXHVT86QB14EbflPo823T7fFcsZgcELd0XQspTRIdJDoNoE4Pcgkol0e6YOc5RGZ5+Ti3Rg8NzzAknDyLS71kw8v90U16FBtDEAKYaK2H3ayviTR4gaoDje+4avBQ0K+op5/mI+jMNrmoV4dsSLOVC0hDw4VeNEdjykWtsMxkzLWSz0QGM8yp2Or4dj9McWftNI7RizKXsGVby3bQLwLk1sScsGWTpGp7T0EXcmi8JBptERyTSdDwHUoR2QkKBdPgR62byHPY5vBcnR0JM3jEesJCeRmliD4LNKK+fwjQkWgFG6MlTE6zyXqdsxtz3asr4bHyRdHV8M3e/Z3ZjMi6vrT0YCZ4sXRXONWbk14Oa8E9tS+//FCAWmjX8NPa8Zt4PNi9LtGJVWLMDRud+B7J7LnBxdPg5dFT271uxWHH/l4FmzlRB15TNa7HPMsiOkxi7XnajycAYWv5hTi/UvOLeidpgQu45a5pempJ2+nd2Vv6bS4TuG77T41l1xJjv07roLLt6v0Wv9NKfJJyeliZiMZ3TH4dH5WMNpcYf7jBYy/lbkXnV1TQg8q1S+W49sqmu5JRxBE0ut+pm2k71EgYKJgDA9kAIEnuXtqlyYkRlnKaKGwx3OyFP4FnwfmthStRaXL4aD3lw4Yz2Os4j68pKUFajH21LfWXU84DbZWBfWVQOM2nCARW64QeRy9ebJ9nlsrD+Lv/DHEDUCQcIgugNeyC76+/neX7cstouY7nZE86+IryBESSGdnV397DAQ841tFQ55q7T8n1N34pguVEADRo1Vn6itiVHdjzL8pmTYMLxlsE87tYNR9gJdkjru7nOKFSm/JZT5RAnrc4LqmzhQB8p0YqGAYuQpkSb9r3KaDgVgVsUvP8kgZ9zN0JRRCrmTQl/aYmc6K/zkceaBEeIayijCpBZkQJqSnMOaa3qlHqgU4S+pe4iRHRk32SlUHLjAdEadUQidQyqe0cyzielnoaoQeMHNufiWn4agcIRFZY7LVAkTO4iZ14d7vvzcnbiSaTb3ynEydnebw3TuIrSEI6YZjFPR+UQIZcDNiH9IOF86+XUe4jLDJahZqif3JCknw17ezJOKXoV97+PTEnSlu5QVoGoM3/N+tJ+nF4CpoU9SiT8zMIrM9Isww5pSd6eNUfr506IgmqMXPysFN4SVLNjONzmC6tpVCcL3EvWs4nCUFjj/QMuPQiNqls4jig75/H9xKSopgTr3/5vI8aLbaj7kE4S6QaupZvEJzVgfCfrAq81yW+anospHBdTSEn4ftA9CDZ69SKrdlRJoIOyzmve2wYaCLHnBooyhSuiuq3DeFgg0fD3yHKp7s/f2cDMB7VttQFcjbnGzfOSOqRMv+Rzut4nyzMW/G5n3FkbOq9Voe9lWMHJ66j4cH7r6FmZPY9PX+aNTyzBrBnSl2gcZv6GpwGwD3aJs14IUBisq0XNSJlEtmN3LWf/q1h4IDyGqNNc5malwdTDvj1gj5DxFT3XX/YR73ZpDqz5I9cTTlv/FDJ/aFy0/1lOzS1G0jjtql7/ZHdubaBmhinIkJBQH3tjBsRYA2ZKdnCAo0hoY5JfECAiw3nUdBJ8dlSK4J22EER4ac7KdhcrXiS6c457y9b48+XCCTo02Fb7ld+Z2Xm3FxlC3wIrWLUAYdzOAAAAABFWElGugAAAEV4aWYAAElJKgAIAAAABgASAQMAAQAAAAEAAAAaAQUAAQAAAFYAAAAbAQUAAQAAAF4AAAAoAQMAAQAAAAIAAAATAgMAAQAAAAEAAABphwQAAQAAAGYAAAAAAAAASAAAAAEAAABIAAAAAQAAAAYAAJAHAAQAAAAwMjEwAZEHAAQAAAABAgMAAKAHAAQAAAAwMTAwAaADAAEAAAD//wAAAqAEAAEAAABoAQAAA6AEAAEAAABoAQAAAAAAAA==",
  //       nominatedYear: "2079"),
  //   CandidateGet(
  //       candidateFirstName: "Pravas",
  //       candidateId: 1,
  //       candidateLastName: "pandey",
  //       candidatePartyName: "Independent",
  //       candidatePartySymbol:
  //           "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",
  //       candidatePhoto:
  //           "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",
  //       nominatedYear: "2079"),
  // ];

  // List<CandidateGet> _candidatesSubMayor = [];

  // Future getCandidate() async {
  //   final response = await http.post(
  //       Uri.parse(
  //           'http://192.168.$url:1214/api/Election/GetNominatedCandidate'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=utf-8',
  //         "Authorization": 'Bearer ${widget.token}'
  //       },
  //       body: jsonEncode(
  //           <String, String>{"flag": widget.localizationString, "year": year}));

  //   log(response.body.toString());
  //   var jsonDataList = jsonDecode(response.body);
  //   // print(jsonDataList.toString());
  //   for (Map<String, dynamic> candidate in jsonDataList) {
  //     final candidates = CandidateGet(
  //       candidateId: candidate["candidateId"],
  //       candidateFirstName: candidate["candidateFirstName"],
  //       candidateLastName: candidate["candidateLastName"],
  //       candidatePhoto: candidate["candidatePhoto"],
  //       candidatePartyName: candidate["candidatePartyName"],
  //       candidatePartySymbol: candidate["candidatePartySymbol"],
  //       nominatedYear: candidate["electionyear"],
  //     );
  //     final postId = candidate["postId"];
  //     setState(() {
  //       postID = postId;
  //       if (postID == 1) {
  //         _candidatesMayor.add(candidates);
  //       } else {
  //         _candidatesSubMayor.add(candidates);
  //       }
  //     });
  //   }
  // }

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<CandidateProvider>(context).fetchCandidate();
    // });

    // getYear();
    // getCandidate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final candidateData =
    //     Provider.of<CandidateProvider>(context, listen: false);
    // final List<CandidateGet> candidatesGet = candidateData.candidate;
    return Scaffold(
        backgroundColor: Colors.white12,
        appBar: AppBar(
          title: Text('voting_screen_sub'.tr,
              style: const TextStyle(fontSize: 19)),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  height: 400,
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 2 / 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10),
                      itemCount: widget.subMayor.length,
                      itemBuilder: (context, index) {
                        return SubMayorSelectableCandidate(
                            widget.subMayor[index].candidateId,
                            widget.subMayor[index].candidateFirstName,
                            widget.subMayor[index].candidateLastName,
                            base64Decode(
                                widget.subMayor[index].candidatePartySymbol),
                            base64Decode(widget.subMayor[index].candidatePhoto),
                            index + 1 == optionSelected,
                            widget.token,
                            widget.encryptedVote);
                      }),
                ),
              ],
            )));
  }
}
