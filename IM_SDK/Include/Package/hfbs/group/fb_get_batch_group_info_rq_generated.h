// automatically generated by the FlatBuffers compiler, do not modify

#ifndef FLATBUFFERS_GENERATED_FBGETBATCHGROUPINFORQ_GROUPPACK_H_
#define FLATBUFFERS_GENERATED_FBGETBATCHGROUPINFORQ_GROUPPACK_H_

#include "flatbuffers.h"

#include "common_generated.h"

namespace grouppack {

struct T_GET_BATCH_GROUP_INFO_RQ;

struct T_GET_BATCH_GROUP_INFO_RQ FLATBUFFERS_FINAL_CLASS : private flatbuffers::Table {
  enum {
    VT_S_RQ_HEAD = 4,
    VT_LIST_GROUP_ID = 6
  };
  const commonpack::S_RQ_HEAD *s_rq_head() const { return GetStruct<const commonpack::S_RQ_HEAD *>(VT_S_RQ_HEAD); }
  const flatbuffers::Vector<uint64_t> *list_group_id() const { return GetPointer<const flatbuffers::Vector<uint64_t> *>(VT_LIST_GROUP_ID); }
  bool Verify(flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<commonpack::S_RQ_HEAD>(verifier, VT_S_RQ_HEAD) &&
           VerifyField<flatbuffers::uoffset_t>(verifier, VT_LIST_GROUP_ID) &&
           verifier.Verify(list_group_id()) &&
           verifier.EndTable();
  }
};

struct T_GET_BATCH_GROUP_INFO_RQBuilder {
  flatbuffers::FlatBufferBuilder &fbb_;
  flatbuffers::uoffset_t start_;
  void add_s_rq_head(const commonpack::S_RQ_HEAD *s_rq_head) { fbb_.AddStruct(T_GET_BATCH_GROUP_INFO_RQ::VT_S_RQ_HEAD, s_rq_head); }
  void add_list_group_id(flatbuffers::Offset<flatbuffers::Vector<uint64_t>> list_group_id) { fbb_.AddOffset(T_GET_BATCH_GROUP_INFO_RQ::VT_LIST_GROUP_ID, list_group_id); }
  T_GET_BATCH_GROUP_INFO_RQBuilder(flatbuffers::FlatBufferBuilder &_fbb) : fbb_(_fbb) { start_ = fbb_.StartTable(); }
  T_GET_BATCH_GROUP_INFO_RQBuilder &operator=(const T_GET_BATCH_GROUP_INFO_RQBuilder &);
  flatbuffers::Offset<T_GET_BATCH_GROUP_INFO_RQ> Finish() {
    auto o = flatbuffers::Offset<T_GET_BATCH_GROUP_INFO_RQ>(fbb_.EndTable(start_, 2));
    return o;
  }
};

inline flatbuffers::Offset<T_GET_BATCH_GROUP_INFO_RQ> CreateT_GET_BATCH_GROUP_INFO_RQ(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RQ_HEAD *s_rq_head = 0,
    flatbuffers::Offset<flatbuffers::Vector<uint64_t>> list_group_id = 0) {
  T_GET_BATCH_GROUP_INFO_RQBuilder builder_(_fbb);
  builder_.add_list_group_id(list_group_id);
  builder_.add_s_rq_head(s_rq_head);
  return builder_.Finish();
}

inline flatbuffers::Offset<T_GET_BATCH_GROUP_INFO_RQ> CreateT_GET_BATCH_GROUP_INFO_RQDirect(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RQ_HEAD *s_rq_head = 0,
    const std::vector<uint64_t> *list_group_id = nullptr) {
  return CreateT_GET_BATCH_GROUP_INFO_RQ(_fbb, s_rq_head, list_group_id ? _fbb.CreateVector<uint64_t>(*list_group_id) : 0);
}

inline const grouppack::T_GET_BATCH_GROUP_INFO_RQ *GetT_GET_BATCH_GROUP_INFO_RQ(const void *buf) {
  return flatbuffers::GetRoot<grouppack::T_GET_BATCH_GROUP_INFO_RQ>(buf);
}

inline bool VerifyT_GET_BATCH_GROUP_INFO_RQBuffer(flatbuffers::Verifier &verifier) {
  return verifier.VerifyBuffer<grouppack::T_GET_BATCH_GROUP_INFO_RQ>(nullptr);
}

inline void FinishT_GET_BATCH_GROUP_INFO_RQBuffer(flatbuffers::FlatBufferBuilder &fbb, flatbuffers::Offset<grouppack::T_GET_BATCH_GROUP_INFO_RQ> root) {
  fbb.Finish(root);
}

}  // namespace grouppack

#endif  // FLATBUFFERS_GENERATED_FBGETBATCHGROUPINFORQ_GROUPPACK_H_
