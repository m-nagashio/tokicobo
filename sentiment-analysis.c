#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include "sentiment-analysis-rest-client.h"
#include "string-utils.h"

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

    int sentiment_code = sendRequest(formatted_input, count);

    return sentiment_code;
}
