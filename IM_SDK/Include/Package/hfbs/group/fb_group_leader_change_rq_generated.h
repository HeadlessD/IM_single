// automatically generated by the FlatBuffers compiler, do not modify

#ifndef FLATBUFFERS_GENERATED_FBGROUPLEADERCHANGERQ_GROUPPACK_H_
#define FLATBUFFERS_GENERATED_FBGROUPLEADERCHANGERQ_GROUPPACK_H_

#include "flatbuffers.h"

#include "common_generated.h"
#include "fb_group_info_generated.h"
#include "fb_group_offline_msg_generated.h"

namespace grouppack {

struct T_GROUP_LEADER_CHANGE_RQ;

struct T_GROUP_LEADER_CHANGE_RQ FLATBUFFERS_FINAL_CLASS : private flatbuffers::Table {
  enum {
    VT_S_RQ_HEAD = 4,
    VT_GROUP_ID = 6,
    VT_OFFLINE_GROUP_MSG = 8
  };
  const commonpack::S_RQ_HEAD *s_rq_head() const { return GetStruct<const commonpack::S_RQ_HEAD *>(VT_S_RQ_HEAD); }
  uint64_t group_id() const { return GetField<uint64_t>(VT_GROUP_ID, 0); }
  const grouppack::T_OFFLINE_GROUP_MSG *offline_group_msg() const { return GetPointer<const grouppack::T_OFFLINE_GROUP_MSG *>(VT_OFFLINE_GROUP_MSG); }
  bool Verify(flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<commonpack::S_RQ_HEAD>(verifier, VT_S_RQ_HEAD) &&
           VerifyField<uint64_t>(verifier, VT_GROUP_ID) &&
           VerifyField<flatbuffers::uoffset_t>(verifier, VT_OFFLINE_GROUP_MSG) &&
           verifier.VerifyTable(offline_group_msg()) &&
           verifier.EndTable();
  }
};

struct T_GROUP_LEADER_CHANGE_RQBuilder {
  flatbuffers::FlatBufferBuilder &fbb_;
  flatbuffers::uoffset_t start_;
  void add_s_rq_head(const commonpack::S_RQ_HEAD *s_rq_head) { fbb_.AddStruct(T_GROUP_LEADER_CHANGE_RQ::VT_S_RQ_HEAD, s_rq_head); }
  void add_group_id(uint64_t group_id) { fbb_.AddElement<uint64_t>(T_GROUP_LEADER_CHANGE_RQ::VT_GROUP_ID, group_id, 0); }
  void add_offline_group_msg(flatbuffers::Offset<grouppack::T_OFFLINE_GROUP_MSG> offline_group_msg) { fbb_.AddOffset(T_GROUP_LEADER_CHANGE_RQ::VT_OFFLINE_GROUP_MSG, offline_group_msg); }
  T_GROUP_LEADER_CHANGE_RQBuilder(flatbuffers::FlatBufferBuilder &_fbb) : fbb_(_fbb) { start_ = fbb_.StartTable(); }
  T_GROUP_LEADER_CHANGE_RQBuilder &operator=(const T_GROUP_LEADER_CHANGE_RQBuilder &);
  flatbuffers::Offset<T_GROUP_LEADER_CHANGE_RQ> Finish() {
    auto o = flatbuffers::Offset<T_GROUP_LEADER_CHANGE_RQ>(fbb_.EndTable(start_, 3));
    return o;
  }
};

inline flatbuffers::Offset<T_GROUP_LEADER_CHANGE_RQ> CreateT_GROUP_LEADER_CHANGE_RQ(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RQ_HEAD *s_rq_head = 0,
    uint64_t group_id = 0,
    flatbuffers::Offset<grouppack::T_OFFLINE_GROUP_MSG> offline_group_msg = 0) {
  T_GROUP_LEADER_CHANGE_RQBuilder builder_(_fbb);
  builder_.add_group_id(group_id);
  builder_.add_offline_group_msg(offline_group_msg);
  builder_.add_s_rq_head(s_rq_head);
  return builder_.Finish();
}

inline const grouppack::T_GROUP_LEADER_CHANGE_RQ *GetT_GROUP_LEADER_CHANGE_RQ(const void *buf) {
  return flatbuffers::GetRoot<grouppack::T_GROUP_LEADER_CHANGE_RQ>(buf);
}

inline bool VerifyT_GROUP_LEADER_CHANGE_RQBuffer(flatbuffers::Verifier &verifier) {
  return verifier.VerifyBuffer<grouppack::T_GROUP_LEADER_CHANGE_RQ>(nullptr);
}

inline void FinishT_GROUP_LEADER_CHANGE_RQBuffer(flatbuffers::FlatBufferBuilder &fbb, flatbuffers::Offset<grouppack::T_GROUP_LEADER_CHANGE_RQ> root) {
  fbb.Finish(root);
}

}  // namespace grouppack

#endif  // FLATBUFFERS_GENERATED_FBGROUPLEADERCHANGERQ_GROUPPACK_H_
