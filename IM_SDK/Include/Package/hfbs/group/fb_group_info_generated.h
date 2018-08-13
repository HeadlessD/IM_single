// automatically generated by the FlatBuffers compiler, do not modify

#ifndef FLATBUFFERS_GENERATED_FBGROUPINFO_GROUPPACK_H_
#define FLATBUFFERS_GENERATED_FBGROUPINFO_GROUPPACK_H_

#include "flatbuffers.h"

#include "common_generated.h"

namespace grouppack {

struct T_GROUP_BASE_INFO;

struct T_GROUP_BASE_INFO FLATBUFFERS_FINAL_CLASS : private flatbuffers::Table {
  enum {
    VT_GROUP_ID = 4,
    VT_GROUP_NAME = 6,
    VT_GROUP_IMG_URL = 8,
    VT_GROUP_COUNT = 10,
    VT_GROUP_MANAGER_USER_ID = 12,
    VT_GROUP_ADD_IS_AGREE = 14,
    VT_GROUP_CT = 16,
    VT_GROUP_REMARK = 18,
    VT_GROUP_MAX_COUNT = 20,
    VT_MESSAGE_STATUS = 22,
    VT_GROUP_ADD_MAX_COUNT = 24
  };
  uint64_t group_id() const { return GetField<uint64_t>(VT_GROUP_ID, 0); }
  const flatbuffers::String *group_name() const { return GetPointer<const flatbuffers::String *>(VT_GROUP_NAME); }
  const flatbuffers::String *group_img_url() const { return GetPointer<const flatbuffers::String *>(VT_GROUP_IMG_URL); }
  int32_t group_count() const { return GetField<int32_t>(VT_GROUP_COUNT, 0); }
  uint64_t group_manager_user_id() const { return GetField<uint64_t>(VT_GROUP_MANAGER_USER_ID, 0); }
  int8_t group_add_is_agree() const { return GetField<int8_t>(VT_GROUP_ADD_IS_AGREE, 0); }
  uint64_t group_ct() const { return GetField<uint64_t>(VT_GROUP_CT, 0); }
  const flatbuffers::String *group_remark() const { return GetPointer<const flatbuffers::String *>(VT_GROUP_REMARK); }
  int32_t group_max_count() const { return GetField<int32_t>(VT_GROUP_MAX_COUNT, 0); }
  int8_t message_status() const { return GetField<int8_t>(VT_MESSAGE_STATUS, 0); }
  int32_t group_add_max_count() const { return GetField<int32_t>(VT_GROUP_ADD_MAX_COUNT, 0); }
  bool Verify(flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<uint64_t>(verifier, VT_GROUP_ID) &&
           VerifyField<flatbuffers::uoffset_t>(verifier, VT_GROUP_NAME) &&
           verifier.Verify(group_name()) &&
           VerifyField<flatbuffers::uoffset_t>(verifier, VT_GROUP_IMG_URL) &&
           verifier.Verify(group_img_url()) &&
           VerifyField<int32_t>(verifier, VT_GROUP_COUNT) &&
           VerifyField<uint64_t>(verifier, VT_GROUP_MANAGER_USER_ID) &&
           VerifyField<int8_t>(verifier, VT_GROUP_ADD_IS_AGREE) &&
           VerifyField<uint64_t>(verifier, VT_GROUP_CT) &&
           VerifyField<flatbuffers::uoffset_t>(verifier, VT_GROUP_REMARK) &&
           verifier.Verify(group_remark()) &&
           VerifyField<int32_t>(verifier, VT_GROUP_MAX_COUNT) &&
           VerifyField<int8_t>(verifier, VT_MESSAGE_STATUS) &&
           VerifyField<int32_t>(verifier, VT_GROUP_ADD_MAX_COUNT) &&
           verifier.EndTable();
  }
};

struct T_GROUP_BASE_INFOBuilder {
  flatbuffers::FlatBufferBuilder &fbb_;
  flatbuffers::uoffset_t start_;
  void add_group_id(uint64_t group_id) { fbb_.AddElement<uint64_t>(T_GROUP_BASE_INFO::VT_GROUP_ID, group_id, 0); }
  void add_group_name(flatbuffers::Offset<flatbuffers::String> group_name) { fbb_.AddOffset(T_GROUP_BASE_INFO::VT_GROUP_NAME, group_name); }
  void add_group_img_url(flatbuffers::Offset<flatbuffers::String> group_img_url) { fbb_.AddOffset(T_GROUP_BASE_INFO::VT_GROUP_IMG_URL, group_img_url); }
  void add_group_count(int32_t group_count) { fbb_.AddElement<int32_t>(T_GROUP_BASE_INFO::VT_GROUP_COUNT, group_count, 0); }
  void add_group_manager_user_id(uint64_t group_manager_user_id) { fbb_.AddElement<uint64_t>(T_GROUP_BASE_INFO::VT_GROUP_MANAGER_USER_ID, group_manager_user_id, 0); }
  void add_group_add_is_agree(int8_t group_add_is_agree) { fbb_.AddElement<int8_t>(T_GROUP_BASE_INFO::VT_GROUP_ADD_IS_AGREE, group_add_is_agree, 0); }
  void add_group_ct(uint64_t group_ct) { fbb_.AddElement<uint64_t>(T_GROUP_BASE_INFO::VT_GROUP_CT, group_ct, 0); }
  void add_group_remark(flatbuffers::Offset<flatbuffers::String> group_remark) { fbb_.AddOffset(T_GROUP_BASE_INFO::VT_GROUP_REMARK, group_remark); }
  void add_group_max_count(int32_t group_max_count) { fbb_.AddElement<int32_t>(T_GROUP_BASE_INFO::VT_GROUP_MAX_COUNT, group_max_count, 0); }
  void add_message_status(int8_t message_status) { fbb_.AddElement<int8_t>(T_GROUP_BASE_INFO::VT_MESSAGE_STATUS, message_status, 0); }
  void add_group_add_max_count(int32_t group_add_max_count) { fbb_.AddElement<int32_t>(T_GROUP_BASE_INFO::VT_GROUP_ADD_MAX_COUNT, group_add_max_count, 0); }
  T_GROUP_BASE_INFOBuilder(flatbuffers::FlatBufferBuilder &_fbb) : fbb_(_fbb) { start_ = fbb_.StartTable(); }
  T_GROUP_BASE_INFOBuilder &operator=(const T_GROUP_BASE_INFOBuilder &);
  flatbuffers::Offset<T_GROUP_BASE_INFO> Finish() {
    auto o = flatbuffers::Offset<T_GROUP_BASE_INFO>(fbb_.EndTable(start_, 11));
    return o;
  }
};

inline flatbuffers::Offset<T_GROUP_BASE_INFO> CreateT_GROUP_BASE_INFO(flatbuffers::FlatBufferBuilder &_fbb,
    uint64_t group_id = 0,
    flatbuffers::Offset<flatbuffers::String> group_name = 0,
    flatbuffers::Offset<flatbuffers::String> group_img_url = 0,
    int32_t group_count = 0,
    uint64_t group_manager_user_id = 0,
    int8_t group_add_is_agree = 0,
    uint64_t group_ct = 0,
    flatbuffers::Offset<flatbuffers::String> group_remark = 0,
    int32_t group_max_count = 0,
    int8_t message_status = 0,
    int32_t group_add_max_count = 0) {
  T_GROUP_BASE_INFOBuilder builder_(_fbb);
  builder_.add_group_ct(group_ct);
  builder_.add_group_manager_user_id(group_manager_user_id);
  builder_.add_group_id(group_id);
  builder_.add_group_add_max_count(group_add_max_count);
  builder_.add_group_max_count(group_max_count);
  builder_.add_group_remark(group_remark);
  builder_.add_group_count(group_count);
  builder_.add_group_img_url(group_img_url);
  builder_.add_group_name(group_name);
  builder_.add_message_status(message_status);
  builder_.add_group_add_is_agree(group_add_is_agree);
  return builder_.Finish();
}

inline flatbuffers::Offset<T_GROUP_BASE_INFO> CreateT_GROUP_BASE_INFODirect(flatbuffers::FlatBufferBuilder &_fbb,
    uint64_t group_id = 0,
    const char *group_name = nullptr,
    const char *group_img_url = nullptr,
    int32_t group_count = 0,
    uint64_t group_manager_user_id = 0,
    int8_t group_add_is_agree = 0,
    uint64_t group_ct = 0,
    const char *group_remark = nullptr,
    int32_t group_max_count = 0,
    int8_t message_status = 0,
    int32_t group_add_max_count = 0) {
  return CreateT_GROUP_BASE_INFO(_fbb, group_id, group_name ? _fbb.CreateString(group_name) : 0, group_img_url ? _fbb.CreateString(group_img_url) : 0, group_count, group_manager_user_id, group_add_is_agree, group_ct, group_remark ? _fbb.CreateString(group_remark) : 0, group_max_count, message_status, group_add_max_count);
}

inline const grouppack::T_GROUP_BASE_INFO *GetT_GROUP_BASE_INFO(const void *buf) {
  return flatbuffers::GetRoot<grouppack::T_GROUP_BASE_INFO>(buf);
}

inline bool VerifyT_GROUP_BASE_INFOBuffer(flatbuffers::Verifier &verifier) {
  return verifier.VerifyBuffer<grouppack::T_GROUP_BASE_INFO>(nullptr);
}

inline void FinishT_GROUP_BASE_INFOBuffer(flatbuffers::FlatBufferBuilder &fbb, flatbuffers::Offset<grouppack::T_GROUP_BASE_INFO> root) {
  fbb.Finish(root);
}

}  // namespace grouppack

#endif  // FLATBUFFERS_GENERATED_FBGROUPINFO_GROUPPACK_H_
