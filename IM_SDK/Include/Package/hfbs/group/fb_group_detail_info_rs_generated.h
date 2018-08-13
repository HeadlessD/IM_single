// automatically generated by the FlatBuffers compiler, do not modify

#ifndef FLATBUFFERS_GENERATED_FBGROUPDETAILINFORS_GROUPPACK_H_
#define FLATBUFFERS_GENERATED_FBGROUPDETAILINFORS_GROUPPACK_H_

#include "flatbuffers.h"

#include "common_generated.h"
#include "fb_group_info_generated.h"

namespace grouppack {

struct T_GROUP_DETAIL_INFO_RS;

struct T_GROUP_DETAIL_INFO_RS FLATBUFFERS_FINAL_CLASS : private flatbuffers::Table {
  enum {
    VT_S_RS_HEAD = 4,
    VT_LIST_MEMBERS_INFO = 6,
    VT_GROUP_ID = 8,
    VT_GROUP_MEMBER_INDEX = 10
  };
  const commonpack::S_RS_HEAD *s_rs_head() const { return GetStruct<const commonpack::S_RS_HEAD *>(VT_S_RS_HEAD); }
  const flatbuffers::Vector<flatbuffers::Offset<commonpack::USER_BASE_INFO>> *list_members_info() const { return GetPointer<const flatbuffers::Vector<flatbuffers::Offset<commonpack::USER_BASE_INFO>> *>(VT_LIST_MEMBERS_INFO); }
  uint64_t group_id() const { return GetField<uint64_t>(VT_GROUP_ID, 0); }
  int32_t group_member_index() const { return GetField<int32_t>(VT_GROUP_MEMBER_INDEX, 0); }
  bool Verify(flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<commonpack::S_RS_HEAD>(verifier, VT_S_RS_HEAD) &&
           VerifyField<flatbuffers::uoffset_t>(verifier, VT_LIST_MEMBERS_INFO) &&
           verifier.Verify(list_members_info()) &&
           verifier.VerifyVectorOfTables(list_members_info()) &&
           VerifyField<uint64_t>(verifier, VT_GROUP_ID) &&
           VerifyField<int32_t>(verifier, VT_GROUP_MEMBER_INDEX) &&
           verifier.EndTable();
  }
};

struct T_GROUP_DETAIL_INFO_RSBuilder {
  flatbuffers::FlatBufferBuilder &fbb_;
  flatbuffers::uoffset_t start_;
  void add_s_rs_head(const commonpack::S_RS_HEAD *s_rs_head) { fbb_.AddStruct(T_GROUP_DETAIL_INFO_RS::VT_S_RS_HEAD, s_rs_head); }
  void add_list_members_info(flatbuffers::Offset<flatbuffers::Vector<flatbuffers::Offset<commonpack::USER_BASE_INFO>>> list_members_info) { fbb_.AddOffset(T_GROUP_DETAIL_INFO_RS::VT_LIST_MEMBERS_INFO, list_members_info); }
  void add_group_id(uint64_t group_id) { fbb_.AddElement<uint64_t>(T_GROUP_DETAIL_INFO_RS::VT_GROUP_ID, group_id, 0); }
  void add_group_member_index(int32_t group_member_index) { fbb_.AddElement<int32_t>(T_GROUP_DETAIL_INFO_RS::VT_GROUP_MEMBER_INDEX, group_member_index, 0); }
  T_GROUP_DETAIL_INFO_RSBuilder(flatbuffers::FlatBufferBuilder &_fbb) : fbb_(_fbb) { start_ = fbb_.StartTable(); }
  T_GROUP_DETAIL_INFO_RSBuilder &operator=(const T_GROUP_DETAIL_INFO_RSBuilder &);
  flatbuffers::Offset<T_GROUP_DETAIL_INFO_RS> Finish() {
    auto o = flatbuffers::Offset<T_GROUP_DETAIL_INFO_RS>(fbb_.EndTable(start_, 4));
    return o;
  }
};

inline flatbuffers::Offset<T_GROUP_DETAIL_INFO_RS> CreateT_GROUP_DETAIL_INFO_RS(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RS_HEAD *s_rs_head = 0,
    flatbuffers::Offset<flatbuffers::Vector<flatbuffers::Offset<commonpack::USER_BASE_INFO>>> list_members_info = 0,
    uint64_t group_id = 0,
    int32_t group_member_index = 0) {
  T_GROUP_DETAIL_INFO_RSBuilder builder_(_fbb);
  builder_.add_group_id(group_id);
  builder_.add_group_member_index(group_member_index);
  builder_.add_list_members_info(list_members_info);
  builder_.add_s_rs_head(s_rs_head);
  return builder_.Finish();
}

inline flatbuffers::Offset<T_GROUP_DETAIL_INFO_RS> CreateT_GROUP_DETAIL_INFO_RSDirect(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RS_HEAD *s_rs_head = 0,
    const std::vector<flatbuffers::Offset<commonpack::USER_BASE_INFO>> *list_members_info = nullptr,
    uint64_t group_id = 0,
    int32_t group_member_index = 0) {
  return CreateT_GROUP_DETAIL_INFO_RS(_fbb, s_rs_head, list_members_info ? _fbb.CreateVector<flatbuffers::Offset<commonpack::USER_BASE_INFO>>(*list_members_info) : 0, group_id, group_member_index);
}

inline const grouppack::T_GROUP_DETAIL_INFO_RS *GetT_GROUP_DETAIL_INFO_RS(const void *buf) {
  return flatbuffers::GetRoot<grouppack::T_GROUP_DETAIL_INFO_RS>(buf);
}

inline bool VerifyT_GROUP_DETAIL_INFO_RSBuffer(flatbuffers::Verifier &verifier) {
  return verifier.VerifyBuffer<grouppack::T_GROUP_DETAIL_INFO_RS>(nullptr);
}

inline void FinishT_GROUP_DETAIL_INFO_RSBuffer(flatbuffers::FlatBufferBuilder &fbb, flatbuffers::Offset<grouppack::T_GROUP_DETAIL_INFO_RS> root) {
  fbb.Finish(root);
}

}  // namespace grouppack

#endif  // FLATBUFFERS_GENERATED_FBGROUPDETAILINFORS_GROUPPACK_H_
