#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>
#include <json-c/json.h>

#include "sentiment-analysis-rest-client.h"

struct Buffer {
    char *data;
    int data_size;
};

size_t buffer_writer(char *ptr, size_t size, size_t nmemb, void *stream) {
    struct Buffer *buf = (struct Buffer *)stream;
    int block = size * nmemb;
    if (!buf) {
        return block;
    }
    if (!buf->data) {
        buf->data = (char *)malloc(block);
    } else {
        buf->data = (char *)realloc(buf->data, buf->data_size + block);
    }
    if (buf->data) {
        memcpy(buf->data + buf->data_size, ptr, block);
        buf->data_size += block;
    }
    return block;
}

const char *sendRequest(char *input) {
    CURL *curl;
    struct Buffer *buffer;

    buffer = (struct Buffer *)malloc(sizeof(struct Buffer));
    buffer->data = NULL;
    buffer->data_size = 0;

    curl = curl_easy_init();
    curl_easy_setopt(curl, CURLOPT_URL, "https://npslfwbq30.execute-api.ap-northeast-1.amazonaws.com/prod");
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, buffer);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, buffer_writer);

    struct curl_slist *headers = NULL;

    headers = curl_slist_append(headers, "Content-Type: application/json;charset=UTF-8");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    char post_data[1024];
    strcpy(post_data, "{\"input_text\": ");
    strcat(post_data, input);
    strcat(post_data, "}");

    curl_easy_setopt(curl, CURLOPT_POST, 1);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, post_data);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, strlen(post_data));

    curl_easy_perform(curl);
    curl_easy_cleanup(curl);

    struct json_object *parsed_json_obj;
    struct json_object *body_obj;

    parsed_json_obj = json_tokener_parse(buffer->data);

    json_object_object_get_ex(parsed_json_obj, "body", &body_obj);

    const char *sentiment = json_object_get_string(body_obj);

    free(buffer->data);
    free(buffer);

    return sentiment;
}
