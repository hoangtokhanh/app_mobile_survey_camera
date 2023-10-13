import 'package:flutter/material.dart';
mixin CameraView {
  Map<String, dynamic> getView() {
    return {
      'edit_view':{
        'fields':[
          {
            'field':'name',
            'label':'Name',
            'type':'text_field',
            'span':6,
            'required':true
          },
          {
            'field':'type',
            'label':'Type',
            'type':'dropdown',
            'span':6,
            'list_string':{
              'value1':'value1',
              'value2':'value2',
              'value3':'value3',
              'value4':'value4',
            },
          },
          {
            'field':'number',
            'label':'Number',
            'span':12,
            'type':'dropdown',
            'list_string':{
              '1':1,
              '2':2,
              '3':3,
              '4':4,
            },
          },
          {
            'field':'link',
            'label':'Link',
            'type':'text_field',
            'span':12
          },
          {
            'field':'viewlink',
            'label':'View link',
            'type':'text_field',
            'span':12
          },
          {
            'field':'des',
            'label':'Description',
            'type':'text_field',
            'span':12,
            'max_line':1
          },
        ],
      },
      'list_view':{
        'fields':[
          {
            'field':'name_with_avatar',
            'label':'Name',
            'type':'name_with_avatar',
            'list_field':[
              {
                'field':'link',
                'type':'image',
              },
              {
                'field':'name',
                'type':'text_field',
              },
            ]
          },
          // {
          //   'field':'link',
          //   'label':'',
          //   'type':'image',
          //   'width':70
          // },
          // {
          //   'field':'name',
          //   'label':'Name',
          //   'type':'text_field',
          // },

          {
            'field':'type',
            'label':'Type',
            'type':'text_field',
          },
          {
            'field':'des',
            'label':'Description',
            'type':'text_field',
          },
        ],
        'show_search':false,
        'show_checkbox':false,
        'buttons':[
          // {
          //   'type':'create',
          //   'label':'Create',
          //   'icon':Icons.add
          // },
          // {
          //   'type':'import',
          //   'label':'Import',
          //   'icon':Icons.cloud_upload_outlined
          // },
          // {
          //   'type':'export',
          //   'label':'Export',
          //   'icon':Icons.cloud_download_outlined
          // }
        ],
        'field_filter':[
        ]
      }
    };
  }
}