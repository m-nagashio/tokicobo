#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include "sentiment-analysis-rest-client.h"
#include "string-utils.h"

const static char *SENTIMENT_POSITIVE = "Positive";
const static char *SENTIMENT_NEGATIVE = "Negative";

const int MAX_KEYWORD_SIZE = 6;

static char positive_keyword1[][10] = {"行","いく"};
static char positive_keyword2[][10] = {"覚"};
static char positive_keyword3[][10] = {"愛", "あい", "あなた", "君", "きみ", "しおり"};

int identify_sentiment(const char *sentiment, char *input, int count) {
    if (strcmp(sentiment, SENTIMENT_NEGATIVE) == 0) {
        return 0;
    }

    if (count == 1) {
        int key1_index_size = sizeof(positive_keyword1)/sizeof(*positive_keyword1);
        for (int i = 0; i < key1_index_size; i ++) {
            if (strstr(input, positive_keyword1[i]) != NULL) {
                return 1;
            }
        }
    } else if (count == 2) {
        int key2_index_size = sizeof(positive_keyword2)/sizeof(*positive_keyword2);
        for (int i = 0; i < key2_index_size; i ++) {
            if (strstr(input, positive_keyword2[i]) != NULL) {
                return 1;
            }
        }
    } else if (count == 3) {
        int key3_index_size = sizeof(positive_keyword3)/sizeof(*positive_keyword3);
        for (int i = 0; i < key3_index_size; i ++) {
            if (strstr(input, positive_keyword3[i]) != NULL) {
                return 1;
            }
        }
    }
    return 0;

}

int analysis(char *input, int count) {
    if (input == NULL || *input == '\0') {
        return 0;
    }
    pop_back(input);
    trim(input);

    char formatted_input[256];
    strcpy(formatted_input, "\"");
    strcat(formatted_input, input);
    strcat(formatted_input, "\"");

    const char *sentiment = sendRequest(formatted_input);

    int sentiment_code = identify_sentiment(sentiment, input, count);

    return sentiment_code;
}
